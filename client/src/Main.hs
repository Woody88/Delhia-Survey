{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}

module Main where

import Control.Monad
import Reflex.Dom hiding (run, Home)
import Reflex.Dom.Routing.Nested
import Util (run)
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.Maybe
import Route
import Common.Session
import Page.Home

main:: IO ()
main = run app

data Model = Model { session :: Session } deriving Show
initModel :: Model
initModel = Model (Session "Random Token")

app :: MonadWidget t m => m ()
app = runRouteWithPathInFragment $ do
  let model = initModel
  switchPromptly never <=< withRoute $ routeMapping model


routeMapping :: MonadWidget t m => Model -> Maybe T.Text ->  m (Event t [T.Text])
routeMapping model = \route -> case parseRoute (fromMaybe "" route) of
  Home        -> homeWidget session_ >> pure never ---(["landing"] <$) <$> button "Open Home"
  Landing     -> (["home"] <$) <$> button "Open Landing"
  _           -> display (constDyn model) >> pure never
  where session_ = session model

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
