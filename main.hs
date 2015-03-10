{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Control.Applicative ((<$>), (<*>))
import Control.Monad (unless)
import Data.Default (def)
import Data.Text (Text)
import Network.HTTP.Conduit (withManager)
import System.Environment (getEnv)
import Web.Authenticate.OAuth (OAuth(..))
import Web.Authenticate.OAuth.CLI (authorizeApp)
import Web.Twitter.Conduit (call, setCredential, twitterOAuth, update)
import Web.Twitter.Types (Status(..), User(..))

import qualified Data.ByteString.Char8 as C8
import qualified Data.Text as T
import qualified Data.Text.IO as T

main :: IO ()
main = do
    oa <- createOAuth
    msg <- T.getContents
    status <- withManager $ \m -> do
        unless (T.length msg > 0) $ fail "tweet is empty"
        unless (T.length msg < 141) $ fail "tweet is too long"

        cred <- authorizeApp "mini-tweet" oa m
        call (setCredential oa cred def) m $ update msg

    T.putStrLn $ statusUrl status

  where
    statusUrl :: Status -> Text
    statusUrl s = T.intercalate "/"
        [ "https://twitter.com"
        , userScreenName $ statusUser s
        , "status"
        , T.pack $ show $ statusId s
        ]

createOAuth :: IO OAuth
createOAuth = toTwitterOAuth
    <$> getEnv "TWITTER_OAUTH_KEY"
    <*> getEnv "TWITTER_OAUTH_SECRET"

  where
    toTwitterOAuth k s = twitterOAuth
        { oauthConsumerKey = C8.pack k
        , oauthConsumerSecret = C8.pack s
        , oauthCallback = Just "oob"
        }
