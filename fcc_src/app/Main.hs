{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc main
-}

module Main (main) where

import ArgParser (debugArgs, getMyArgs, Arguments (Arguments, input))
import Error.MaybeError (printMaybeError, MaybeError (..))
import Error.ErrorList (fileError)
import Control.Exception (try, catch, Exception)
import Data.Functor ((<&>))
import System.IO (readFile)
import GHC.IO.Exception (IOException(IOError))
import Data.Maybe (fromMaybe)
import Data.Function ((&))

setInput :: Arguments -> [String] -> Arguments
setInput a s = a { input = s }

readAllFiles :: (MaybeError Arguments) -> IO (MaybeError Arguments)
readAllFiles a = sequence
  (a <&>
   (\a' -> (mapM readFile $ input a') <&> setInput a'))

manageIoError :: IOException -> MaybeError a
manageIoError (IOError _ _ _ _ _ file) = Error fileError (fromMaybe "" file)

checkErrors :: IO (MaybeError a) -> IO (MaybeError a)
checkErrors x = try x <&>
  (\err -> case err of
             Left e -> manageIoError e
             Right a -> a
  )

parseArgs :: Arguments -> MaybeError String
parseArgs = return . show

main :: IO ()
main = do
  args <- getMyArgs
  readArgs <- checkErrors $ readAllFiles args
  let parsedArgs = readArgs >>= parseArgs
  printMaybeError putStrLn parsedArgs
