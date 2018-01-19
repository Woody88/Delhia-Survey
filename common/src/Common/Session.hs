module Common.Session where

import Data.Text as T

data Session = Session { token :: Token } deriving Show

type Token = T.Text
