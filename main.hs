{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import MiniTweet.Authorize

import Control.Monad (unless, when, void)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Monoid ((<>))
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.FilePath ((</>))
import System.IO (hIsTerminalDevice, stdin)
import Network.HTTP.Conduit (withManager)
import Web.Twitter.Conduit (call, homeTimeline, update)
import Web.Twitter.Types (Status(..), User(..))

import qualified Data.Text as T
import qualified Data.Text.IO as T

main :: IO ()
main = do
    piped <- fmap not $ hIsTerminalDevice stdin

    withManager $ \m -> do
        twInfo <- authorizeApp m =<< cacheFile

        when piped $ do
            status <- liftIO $ fmap T.strip $ T.getContents

            unless (T.length status > 0) $ fail "tweet is empty"
            unless (T.length status < 141) $ fail "tweet is too long"

            void $ call twInfo m $ update status

        mapM_ printStatus =<< call twInfo m homeTimeline

printStatus :: MonadIO m => Status -> m ()
printStatus s = liftIO $ T.putStrLn $ "@" <> user <> ": " <> statusText s

  where
    user = userScreenName $ statusUser s

cacheFile :: MonadIO m => m FilePath
cacheFile = liftIO $ do
    dir <- getUserCacheDir "mini-tweet"
    return $ dir </> "credential"
