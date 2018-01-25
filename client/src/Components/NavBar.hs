{-# LANGUAGE OverloadedStrings #-}
module Components.NavBar where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as Map
import Data.Monoid

blackText :: T.Text
blackText = "grey-text text-darken-3"

navBarWidget :: MonadWidget t m => m ()
navBarWidget = do
  elAttr "nav" navAttr $ do
    elClass "div" "nav-wrapper container" $ do
      logoSection
      navigationLinks
      hamburgerNav
  where navAttr = ("class" =: "grey lighten-5") <> ("role" =: "navigation")

logoSection :: MonadWidget t m => m ()
logoSection = elClass "a" (blackText <> "brand-logo") $ text "Logo"

navigationLinks :: MonadWidget t m => m ()
navigationLinks = do
  elClass "ul" "right hide-on-med-and-down" $ do
    el "li" $ do
      elAttr "a" linksAttr $ text "Nav Link"
  where linksAttr = ("href" =: "#") <> ("class" =: blackText)

hamburgerNav :: MonadWidget t m => m ()
hamburgerNav = do
  elAttr "ul" hamAttr $ do
    el "li" $ do
      elAttr "a" ("href" =: "#") $ text "Nav Link"
  where hamAttr = ("style" =: "transform: translateX(-100%);")
