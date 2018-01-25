{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}

module Main where

import Control.Monad
import Reflex.Dom hiding (run, Home)
import Reflex.Dom.Routing.Nested
import Util ((=>>))
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.Maybe
import Route
import System.FilePath
import Common.Session
import Page.Home
import Page.Landing
import Page.SurveyRegister
import Page.Errored

main:: IO ()
main = putStrLn "hello"


-- app' :: MonadWidget t m => m ()
-- app' = do
--   app
--

data Model = Model { session :: Session
                   , surveyCompleted :: Bool
                   } deriving Show

data Action = RegisterToken Session
            | NoAction
            | SurveyFinished

noAction :: MonadWidget t m => m (Event t Action)
noAction = pure $ (NoAction <$ never)

initialModel :: Model
initialModel = Model (Session "user") False

app :: MonadWidget t m => m ()
app = runRouteWithPathInFragment $ mdo
  let model  = initialModel
  switchPromptly never <=< withRoute $ routeMapping model

routeMapping :: MonadWidget t m => Model -> Maybe T.Text ->  m (Event t [T.Text])
routeMapping model = \route -> mdo
  dynModel <- foldDyn update model action
  --display dynModel
  let session_ = session model
  (routeMap, action) <- router session_ route
  pure routeMap


router :: MonadWidget t m => Session -> Maybe T.Text -> m (Event t [T.Text], Event t Action)
router session_ = \route -> do
  let router_ = case parseRoute $ fromMaybe "" route of
                  Home           -> pageWidget homeWidget           =>> ( (SurveyFinished <$) <$> button "Send Form" )
                  Landing        -> pageWidget landingWidget        =>> noAction
                  SurveyRegister -> pageWidget surveyRegisterWidget =>> noAction
                  Errored        -> pageWidget erroredWidget        =>> noAction
                  Blank          -> redirectToLanding
                  _              -> redirectToErrored
  pairEventM $ handler router_

  where pageWidget   = \p -> pageWidget' session_ p >> pure never
        pairEventM   = \(rEv, acEv) -> rEv >>= \r -> acEv >>= \a -> pure (r, a)
        handler :: MonadWidget t m => (m (Event t [T.Text]), m (Event t Action)) -> (m (Event t [T.Text]), m (Event t Action))
        handler router_ =  if token session_ == "" then redirectToLanding else router_
        redirectToLanding :: MonadWidget t m => (m (Event t [T.Text]), m (Event t Action))
        redirectToLanding = do redirectLocally [toLink Landing] =>> noAction
        redirectToErrored   = do redirectLocally [toLink Errored] =>> noAction


pageWidget' :: MonadWidget t m => Session -> (Session -> m a) -> m ()
pageWidget' = \session_ p -> do
  p session_
  javascript "https://code.jquery.com/jquery-3.2.1.min.js"
  javascript "https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"
  javascript "assets/js/initializer.js"
  where javascript j = elAttr "script" (Map.fromList [("src", j)]) $ pure ()

(<<) :: Monad m => m b -> m a -> m b
(<<) = flip (>>)

update :: Action -> Model -> Model
update NoAction model = model
update SurveyFinished model = model { surveyCompleted = True }

myButton :: MonadWidget t m => T.Text -> m (Event t ())
myButton lbl = do
  (e, _) <- elAttr' "a" ("class" =: "button") $ text lbl
  pure $ domEvent Click e

--  Old way of doing routing ---
-- view :: (MonadWidget t m) => Dynamic t Model -> m (Event t Action)
-- view model = switchPromptly never <=< dyn $ ffor model (\m -> if (parseRoute $ route m ) == Landing then page else page2 )

--- Old way of changing url address bar ---
-- let uri = parseURI $ T.unpack . T.concat $ ["http://localhost:8080/", path]
--     s = SerializedScriptValue jsNull
--     history = HistoryCommand_PushState (HistoryStateUpdate s path uri)
--     h :: MonadWidget t m => m (Dynamic t HistoryItem)
--     h = manageHistory (history <$ never)
-- in model { route = path }
