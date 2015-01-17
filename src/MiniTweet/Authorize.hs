{-# LANGUAGE OverloadedStrings #-}
module MiniTweet.Authorize
    ( authorizeApp
    ) where

import MiniTweet.Cache
import MiniTweet.OAuth

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Default (def)
import Network.HTTP.Conduit (Manager)
import System.IO (hFlush, stdout)
import Web.Twitter.Conduit (TWInfo, setCredential)

import qualified Data.ByteString.Char8 as C8
import qualified Web.Authenticate.OAuth as OA

authorizeApp :: MonadIO m => Manager -> FilePath -> m TWInfo
authorizeApp m fp = do
    cred <- withCacheFile fp $ do
        c <- OA.getTemporaryCredential oauth m
        pin <- liftIO $ do
            putStrLn $ "Please visit the following URL to grant access:"
            putStrLn $ OA.authorizeUrl oauth c
            putStr "PIN: "
            hFlush stdout

            C8.getLine

        OA.getAccessToken oauth (OA.insert "oauth_verifier" pin c) m

    return $ setCredential oauth cred def
