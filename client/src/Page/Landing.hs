{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
module Page.Landing where

import Common.Session
import Components.NavBar
import Reflex.Dom hiding (Home)
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.Monoid
import Route

landingWidget :: MonadWidget t m => Session -> m ()
landingWidget session_ = do
  elClass "div" "full-page" $ do
    jumboView

jumboView :: MonadWidget t m => m ()
jumboView = do
  elClass "div" "section valign-wrapper full-page" $ do
    elClass "div" "container center-align" $ do
      elClass "h1" "header center" $ text "Hey There, Thank you for Coming!"
      elClass "div" "row center" $ do
        elClass "h5" "header col s12 light" $ text "This suvey will help us better understand what our customer will need."
        elClass "div" "row center" $ do
          elAttr "a"  startBtnAttr $ text "Let's Do It!"
  where startBtnAttr = ("class" =: "btn-large waves-effect waves-light orange") <>  ("href" =: toLinkFrag SurveyRegister)
