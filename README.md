# mini-tweet

Twitter client with intentionally few features.

## Installation

```
git clone https://github.com/pbrisbin/authenticate-oauth-cli
git clone https://github.com/pbrisbin/mini-tweet
cd mini-tweet
cabal sandbox init
cabal sandbox add-source ../authenticate-oauth-cli
cabal install --dependencies-only
cabal build
ln -s dist/build/mt/mt ~/.cabal/bin/mt  # or anywhere in $PATH
```

## Usage

- Create an [OAuth application][create] on twitter
- Note the Consumer Key and Secret

[create]: https://apps.twitter.com/app/new

```
% export TWITTER_OAUTH_KEY="..."
% export TWITTER_OAUTH_SECRET="..."
% echo 'sup?' | mt
https://twitter.com/you/status/12356
```
