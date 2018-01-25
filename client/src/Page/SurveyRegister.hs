{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
module Page.SurveyRegister where

import Common.Session
import Page.Survey.Forms
import Reflex.Dom


surveyRegisterWidget :: MonadWidget t m => Session -> m ()
surveyRegisterWidget session_ = do
  elClass "div" "full-page" $ do
    elClass "div" "section valign-wrapper full-page" $ do
      elClass "div" "container center-align" $ do
        elClass "div" "row" $ do
          stageOneForm
