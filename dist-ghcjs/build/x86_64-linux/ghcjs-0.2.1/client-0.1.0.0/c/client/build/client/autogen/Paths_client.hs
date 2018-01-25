{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_client (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/woodson/.cabal/bin"
libdir     = "/home/woodson/.cabal/lib/x86_64-linux-ghcjs-0.2.1-ghc8_0_2/client-0.1.0.0-inplace-client"
dynlibdir  = "/home/woodson/.cabal/lib/x86_64-linux-ghcjs-0.2.1-ghc8_0_2"
datadir    = "/home/woodson/.cabal/share/x86_64-linux-ghcjs-0.2.1-ghc8_0_2/client-0.1.0.0"
libexecdir = "/home/woodson/.cabal/libexec/x86_64-linux-ghcjs-0.2.1-ghc8_0_2/client-0.1.0.0"
sysconfdir = "/home/woodson/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "client_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "client_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "client_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "client_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "client_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "client_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
