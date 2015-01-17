{-# LANGUAGE OverloadedStrings #-}
module MiniTweet.Status
    ( postStatus
    ) where

import Data.Text (Text)
import Web.Twitter.Conduit (TWInfo, call, update)
import Web.Twitter.Types (Status(..), User(..))
import Network.HTTP.Conduit (withManager)

import qualified Data.Text as T

postStatus :: TWInfo -> Text -> IO Text
postStatus twInfo status = withManager $ \m ->
    fmap toUrl $ call twInfo m $ update status

toUrl :: Status -> Text
toUrl s = T.intercalate "/"
    [ "https://twitter.com"
    , userName $ statusUser s
    , "status"
    , T.pack $ show $ statusId s
    ]
