module Main (main) where

import MiniTweet

import Control.Monad (unless, when)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.FilePath ((</>))
import System.IO (hIsTerminalDevice, stdin)

import qualified Data.Text as T
import qualified Data.Text.IO as T

main :: IO ()
main = do
    piped <- fmap not $ hIsTerminalDevice stdin

    when piped $ do
        twInfo <- authorizeApp =<< cacheFile
        status <- fmap T.strip $ T.getContents

        unless (T.length status > 0) $ fail "tweet is empty"
        unless (T.length status < 141) $ fail "tweet is too long"

        T.putStrLn =<< postStatus twInfo status

cacheFile :: IO FilePath
cacheFile = do
    dir <- getUserCacheDir "mini-tweet"
    return $ dir </> "credential"
