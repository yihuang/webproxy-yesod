module Paths_webproxy_yesod (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,0,0], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/huangyi/work/haskell/webproxy-yesod/cabal-dev//bin"
libdir     = "/home/huangyi/work/haskell/webproxy-yesod/cabal-dev//lib/webproxy-yesod-0.0.0/ghc-7.0.3"
datadir    = "/home/huangyi/work/haskell/webproxy-yesod/cabal-dev//share/webproxy-yesod-0.0.0"
libexecdir = "/home/huangyi/work/haskell/webproxy-yesod/cabal-dev//libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "webproxy_yesod_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "webproxy_yesod_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "webproxy_yesod_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "webproxy_yesod_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
