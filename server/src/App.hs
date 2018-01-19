{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PolyKinds         #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE TypeOperators     #-}

module App where


import Network.Wai.Logger       (withStdoutLogger)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Network.Wai.Handler.Warp
import Network.Wai
import Servant
import Common

type API = "woodson" :> Get '[JSON] String

runApp :: IO ()
runApp = withStdoutLogger $ \aplogger -> do
  let settings = setPort serverPort $ setLogger aplogger defaultSettings
  putStrLn serverMessage >> (runSettings settings $ logger $ app)
  where logger        = logStdoutDev
        serverPort    = 8000
        serverMessage = "Server Running on port: " ++ (show serverPort)


app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = func
  where func = pure "Woodson"
