{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc main
-}

module Main (main) where

import ArgParser (debugArgs, getMyArgs, Arguments (Arguments))
import Error.MaybeError (printMaybeError, MaybeError (..))
import Error.ErrorList (fileError)
import Control.Exception (try)
import Data.Functor ((<&>))

infixl 1 >>=-
(>>=-) :: IO (MaybeError Arguments) -> (Arguments -> IO (MaybeError Arguments))
  -> IO (MaybeError Arguments)
ioma >>=- f = ioma >>= \ma -> case ma of
  Correct a -> f a
  Error et em -> return $ Error et em

maybeReadFile :: String -> IO (MaybeError String)
maybeReadFile file = ioResult <&>
  (\r -> case r of
    Left _ -> Error fileError file
    Right content -> Correct content
  )
  where ioResult = try (readFile file) :: IO (Either IOError String)

maybeReadAllFiles :: Arguments -> IO (MaybeError Arguments)
maybeReadAllFiles (Arguments a b c d) = newArgs
  where files = mapM maybeReadFile a :: IO ([MaybeError String])
        filesErr = sequence <$> files
        newArgs = (\aNoIo -> (\newA -> (Arguments newA b c d)) <$> aNoIo)
          <$> filesErr

main :: IO ()
main = getMyArgs >>=- maybeReadAllFiles >>= (printMaybeError debugArgs)
