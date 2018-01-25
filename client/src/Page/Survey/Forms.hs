{-# LANGUAGE OverloadedStrings #-}

module Page.Survey.Forms where

import Reflex.Dom
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.Monoid

data Action
  = StudentSel
  | WorkerSel

stageOneForm :: MonadWidget t m => m ()
stageOneForm = do
    stageOneForm'
    blank

stageOneForm' :: MonadWidget t m => m (Event t ())
stageOneForm' = do
  elClass "form" "col s12" $ do
    occupationInput
    ageInput
    ethnecityInput
    countryInput
  pure never

subscribeButton :: MonadWidget t m => m (Event t ())
subscribeButton = do
  elClass "div" "row" $ do
    (e, _) <- elAttr' "button" btnAttr $ text "Subscribe"
    pure $ domEvent Click e
  where btnAttr = ("type" =: "submit") <> ("class" =: "btn waves-effect waves-light")

ageInput :: MonadWidget t m => m (TextInput t)
ageInput = do
  elClass "div" "row" $ do
    elClass "div" "input-field col s12 m6 offset-m3" $ do
      elAttr "label" ("for" =: "age") $ text "Age"
      ageInput'
  where ageInput'    = textInput $ def & attributes                .~ constDyn ageInputAttr
                                       & textInputConfig_inputType .~ "number"
        ageInputAttr = ("placeholder" =: "How old are you?") <> ("id" =: "age")

ethnecityInput :: MonadWidget t m => m (TextInput t)
ethnecityInput = do
  elClass "div" "row" $ do
    elClass "div" "input-field col s12 m6 offset-m3" $ do
      elAttr "label" ("for" =: "ethnecity") $ text "Ethnecity"
      ageInput'
  where ageInput'    = textInput $ def & attributes                .~ constDyn ethnecityInputAttr
                                       & textInputConfig_inputType .~ "text"
        ethnecityInputAttr = ("placeholder" =: "What is your ethnecity? I.e: Black, White, Hispanic...") <> ("id" =: "ethnecity")

occupationInput :: MonadWidget t m => m (Event t Action)
occupationInput =
  elClass "div" "row" $ do
    (stEv, _) <- elClass' "a" "waves-effect waves-teal btn-flat btn" $ do
                  text "Student"
    (stEv, _) <- elClass' "a" "waves-effect waves-teal btn-flat btn" $ do
                  text "Worker"
    let studentEv = (StudentSel <$) $ domEvent Click stEv
        workerEv  = (WorkerSel  <$) $ domEvent Click stEv
    pure $ leftmost [studentEv, workerEv]

countryInput :: MonadWidget t m => m (Dropdown t Int)
countryInput =
  elClass "div" "row" $ do
    elClass "div" "input-field col s6 m3 offset-m3" $ do
      dropdown 5 (constDyn countries) def

countries :: Map.Map Int T.Text
countries = Map.fromList [(1, "France"), (2, "Switzerland"), (3, "Germany"), (4, "Italy"), (5, "USA")]

emailInput :: MonadWidget t m => m (TextInput t)
emailInput = do
  elClass "div" "row" $ do
    elClass "div" "input-field col s6 m3 offset-m3" $ do
      let eInput = textInput $ def & attributes .~ constDyn emailInputAttr
      elAttr "label" ("for" =: "email") $ text "Email"
      eInput
  where emailInputAttr = ("placeholder" =: "Email")  <> ("type" =: "email") <> ("class" =: "validate") <> ("id" =: "email")

--   <div class="row">
--   <form class="col s12">
--     <div class="row">
--       <div class="input-field col s6">
--         <input placeholder="Placeholder" id="first_name" type="text" class="validate">
--         <label for="first_name">First Name</label>
--       </div>
--       <div class="input-field col s6">
--         <input id="last_name" type="text" class="validate">
--         <label for="last_name">Last Name</label>
--       </div>
--     </div>
--     <div class="row">
--       <div class="input-field col s12">
--         <input disabled value="I am not editable" id="disabled" type="text" class="validate">
--         <label for="disabled">Disabled</label>
--       </div>
--     </div>
--     <div class="row">
--       <div class="input-field col s12">
--         <input id="password" type="password" class="validate">
--         <label for="password">Password</label>
--       </div>
--     </div>
--     <div class="row">
--       <div class="input-field col s12">
--         <input id="email" type="email" class="validate">
--         <label for="email">Email</label>
--       </div>
--     </div>
--     <div class="row">
--       <div class="col s12">
--         This is an inline input field:
--         <div class="input-field inline">
--           <input id="email" type="email" class="validate">
--           <label for="email" data-error="wrong" data-success="right">Email</label>
--         </div>
--       </div>
--     </div>
--   </form>
-- </div>
