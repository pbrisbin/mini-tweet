# mini-tweet

Twitter client with intentionally few features.

## Usage

```
% echo 'sup?' | mt
https://twitter.com/you/status/12356
```

## Installation

*TODO*: Binary package. For now, see Development Installation.

## Development Installation

- Create an [OAuth application][create] on twitter
- Note the Consumer Key and Secret
- Clone this repository
- Create the following source file:

[create]: https://apps.twitter.com/app/new

**src/MiniTweet/OAuth.hs**

```hs
{-# LANGUAGE OverloadedStrings #-}
module MiniTweet.OAuth
    ( oauth
    ) where

import Web.Authenticate.OAuth (OAuth(..))
import Web.Twitter.Conduit (twitterOAuth)

oauth :: OAuth
oauth = twitterOAuth
    { oauthConsumerKey = "TODO"
    , oauthConsumerSecret = "TODO"
    , oauthCallback = Just "oob"
    }
```

- Execute `cabal install` to put `mt` in `~/.cabal/bin`, or
- Execute `cabal install --dependencies-only` and use `cabal run`
