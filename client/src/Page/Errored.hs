{-# LANGUAGE OverloadedStrings #-}

module Page.Errored (erroredWidget) where

import Common.Session
import Reflex.Dom
import qualified Data.Map as Map
import qualified Data.Text as T

erroredWidget :: MonadWidget t m => Session -> m ()
erroredWidget session_ = do
  el "h2" $ text "Could Not Find Page!"
