# mini-tweet

Twitter client with intentionally few features.

## Installation

```
cabal install
```

## OAuth

- Create an [OAuth application][create] on twitter
- Note the Consumer Key and Secret

## Usage

```
% export TWITTER_OAUTH_KEY="..."
% export TWITTER_OAUTH_SECRET="..."
% echo 'sup?' | mt
https://twitter.com/you/status/12356
```
