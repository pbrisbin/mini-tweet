{-# LANGUAGE OverloadedStrings #-}
module Web.Authenticate.OAuth.CLI
    ( authorizeApp
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Network.HTTP.Conduit (Manager)
import System.Directory (createDirectoryIfMissing)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.FilePath ((</>), takeDirectory)
import System.IO (hFlush, stdout)

import qualified Control.Exception as E
import qualified Data.ByteString.Char8 as C8
import qualified Web.Authenticate.OAuth as OA

-- | Authorize the application for OAuth
authorizeApp :: MonadIO m => String -> OA.OAuth -> Manager -> m OA.Credential
authorizeApp name oauth m = do
    fp <- cacheFile name

    withCacheFile fp $ do
        c <- OA.getTemporaryCredential oauth m
        pin <- liftIO $ do
            putStrLn $ "Please visit the following URL to grant access:"
            putStrLn $ OA.authorizeUrl oauth c
            putStr "PIN: "
            hFlush stdout

            C8.getLine

        OA.getAccessToken oauth (OA.insert "oauth_verifier" pin c) m

withCacheFile :: (MonadIO m, Read a, Show a) => FilePath -> m a -> m a
withCacheFile fp f = maybe (putCache fp =<< f) return =<< getCache fp

getCache :: (MonadIO m, Read a) => FilePath -> m (Maybe a)
getCache fp = liftIO $ readCache `E.catch` discard

  where
    readCache :: Read a => IO (Maybe a)
    readCache = fmap (Just . read) $ readFile fp

    discard :: E.SomeException -> IO (Maybe a)
    discard _ = return Nothing

putCache :: (MonadIO m, Show a) => FilePath -> a -> m a
putCache fp v = liftIO $ do
    createDirectoryIfMissing True $ takeDirectory fp
    const (return v) $ writeFile fp $ show v

cacheFile :: MonadIO m => String -> m FilePath
cacheFile name = liftIO $ do
    dir <- getUserCacheDir name
    return $ dir </> "credential"
