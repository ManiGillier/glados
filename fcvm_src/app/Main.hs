{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcvm main
-}

module Main (main) where

import FileOpening.FileToBytecode ( fileToByteCode )
import System.IO
import Prelude
import System.Environment
import System.Exit (exitWith, ExitCode(..))
import VM.Executor (execFccByteCode, execAllByteCodes, printVMIO)
import Data.Functor ((<&>))
import Data.Maybe (listToMaybe)

printArgError :: IO ()
printArgError = hPutStrLn stderr "ERROR: You must provide a file as argument."

getFirstArg :: IO String
getFirstArg = getArgs >>=
  (\args -> case listToMaybe args of
      Nothing -> printArgError >> exitWith (ExitFailure 84)
      Just arg' -> return arg')

main :: IO ()
main = getFirstArg >>= fileToByteCode <&>
  execFccByteCode <&> execAllByteCodes >>= printVMIO
