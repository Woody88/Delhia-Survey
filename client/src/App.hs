module App where

data Model = Model { session :: Session
                   , surveyCompleted :: Bool
                   } deriving Show

data Action = RegisterToken Session
            | SurveyCompleted
            | NoAction

initModel :: Model
initModel = Model (Session "Random Token") False
