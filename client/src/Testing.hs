{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE JavaScriptFFI      #-}
module Testing where

-- import           Language.Javascript.JSaddle
-- import           Language.Javascript.JSaddle.Warp
-- import           Reflex.Dom.Core (mainWidget, mainWidgetWithHead)
import           Reflex.Dom --hiding (mainWidget,mainWidgetWithHead, run)
import           JSDOM.Types
import qualified Data.Text as T
import qualified Data.Map as Map
import           Data.Monoid ((<>))
import           Control.Monad.Trans (liftIO)

main :: IO ()
main = mainWidget testLinks

-- main :: IO ()
-- main = run 3000 $ mainWidget $ app
--
-- app :: MonadWidget t m => m ()
-- app = el "div" $ blank

main :: IO ()
main = run 8000 $ mainWidgetWithHead headSection testJSFFI

testJSFFI :: MonadWidget t m => m ()
testJSFFI = do
  (e, _) <- elClass' "a" "btn primary" $ text "Click Me!"
  doc <- liftJSM $ jsg "document"
  pure ()

headSection :: MonadWidget t m => m ()
headSection = do
  elAttr "meta" ("charset" =: "utf-8") $ pure ()
  elAttr "meta" (Map.fromList [("name", "viewport"), ("content", "width=device-width, initial-scale=1.0")]) $ pure ()
  stylesheet "https://fonts.googleapis.com/icon?family=Material+Icons"
  stylesheet "https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.min.css"
  stylesheet "https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"
  where stylesheet s = elAttr "link" (Map.fromList [("rel", "stylesheet"), ("href", s)]) $ pure ()

testLinks :: MonadWidget t m => m ()
testLinks = do
  a <- link "Click Me"
  dyn_text <- holdDyn "" $ "Clicked" <$ _link_clicked a
  dynText dyn_text
