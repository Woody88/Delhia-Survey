{-# LANGUAGE OverloadedStrings #-}
module Route (Route(..), RouteParser(..), Location) where

import Reflex.Dom.Location
import qualified Data.Text as T
import qualified Data.Map  as Map
import Data.Monoid
import Data.Maybe
import Language.Javascript.JSaddle
import JSDOM.Types hiding (Location, Event)
import Network.URI

data Route
  = Home
  | SurveyRegister
  | Landing
  | Survey
  | Errored
  | Blank
  deriving (Show, Eq, Ord)

type Location = T.Text
type Routing = Map.Map Route T.Text

(=:) :: k -> a -> Map.Map k a
(=:) = Map.singleton

routings :: Routing
routings = topRouting
        <> badRoute
        <> (Blank          =: "")
        <> (Landing        =: "landing")
        <> (SurveyRegister =: "survey_register")
        <> (Survey         =: "surey")

topRouting :: Routing
topRouting = (Home =: "home")

badRoute :: Routing
badRoute = (Errored =: "404")

class RouteParser a where
  parseRoute :: Location -> a
  toLink     :: a -> Location
  toLinkFrag :: a -> Location

instance RouteParser Route where
  parseRoute location = if isPathFound then Errored else fst . Map.elemAt 0 $ parsedLocation
    where parsedLocation :: Routing
          parsedLocation = Map.filter (==location) routings
          isPathFound = parsedLocation == Map.empty
  toLink r = Map.findWithDefault "404" r routings
  toLinkFrag = addFragToLink . toLink
    where addFragToLink :: Location -> Location
          addFragToLink = (<>) "#"



-- changeRoute :: (MonadWidget t m) => Location -> m (Event t HistoryItem)
-- changeRoute = \path -> do
--    let uri = parseURI $ T.unpack . T.concat $ ["http://localhost:8080/", path]
--    dynHistory <- manageHistory $ historyManager path uri <$ never
--    pure $ updated dynHistory
--   where serializedScript = SerializedScriptValue jsNull
--         historyManager = \title uri ->  HistoryCommand_PushState (HistoryStateUpdate serializedScript title uri)
