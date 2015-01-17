module MiniTweet.Cache
    ( withCacheFile
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import System.FilePath (takeDirectory)
import System.Directory (createDirectoryIfMissing)

import qualified Control.Exception as E

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
