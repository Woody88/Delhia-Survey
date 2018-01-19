{-# LANGUAGE OverloadedStrings #-}
module Route (Route(..), RouteParser(..), Location) where

import Reflex.Dom (MonadWidget, Event, updated, never)
import Reflex.Dom.Location
import qualified Data.Text as T
import Data.Semigroup ((<>), Semigroup)
import Language.Javascript.JSaddle
import JSDOM.Types hiding (Location, Event)
import Network.URI


data Route
  = Landing
  | Survey
  | Home
  | Error
  deriving (Show, Eq)

type Location = T.Text

class RouteParser a where
  parseRoute :: Location -> a
  toLink :: a -> Location

instance RouteParser Route where
  parseRoute = \location ->
    case location of
      "home"    -> Home
      "" -> Landing
      "survey"  -> Survey
      _          -> Error

  toLink = \r ->
    case r of
      Home    -> "home"
      Landing -> "landing"
      Survey  -> "survey"
      Error   -> "404"

-- withRoute :: (MonadWidget t m, Semigroup a) => Location -> m (Event t a) -> m (Event t a)
-- withRoute loc evTrigger = evToRoute =<< changeRoute loc
--   where evToRoute = \ev -> do
--                      evT <- evTrigger
--                      pure $ ev <> evT

changeRoute :: (MonadWidget t m) => Location -> m (Event t HistoryItem)
changeRoute = \path -> do
   let uri = parseURI $ T.unpack . T.concat $ ["http://localhost:8080/", path]
   dynHistory <- manageHistory $ historyManager path uri <$ never
   pure $ updated dynHistory
  where serializedScript = SerializedScriptValue jsNull
        historyManager = \title uri ->  HistoryCommand_PushState (HistoryStateUpdate serializedScript title uri)
