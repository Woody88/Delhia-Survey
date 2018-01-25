{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE TemplateHaskell #-}
module Page.Home (homeWidget) where

import Common.Session
import Reflex.Dom
import qualified Data.Map as Map
import qualified Data.Text as T

data Action
  = Subscribe

data Model = Model { subscribed :: Bool } deriving Show

initialModel :: Model
initialModel = Model False

homeWidget :: MonadWidget t m => Session ->  m ()
homeWidget session = mdo
  changes <- view session model
  model   <- foldDyn (update session) initialModel changes
  pure ()


view :: MonadWidget t m => Session -> Dynamic t Model -> m (Event t Action)
view session model = do
  -- subscribeEmailInput <- textInput $ def & attributes .~ constDyn ("Placeholder" =: "Email")
  evSubscribe <- button "Subscribe"
  elAttr "a" ("href" =: "#landing") $ text "Landing Page"
  pure $ leftmost [Subscribe <$ evSubscribe]


update :: Session -> Action -> Model -> Model
update session Subscribe model = model { subscribed = True }
