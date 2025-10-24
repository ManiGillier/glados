{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcvm main
-}

module Main (main) where

import FileOpening.FileToBytecode
import System.IO
import System.IO.Error
import Prelude
import System.Environment
import Data.Word
import System.Exit (exitWith, ExitCode(..))
import VM.Executor (execFccByteCode, execAllByteCodes, printVMIO)
import Error.MaybeError
import Data.Functor ((<&>))

ioErrorReturn :: IOError -> IO ()
ioErrorReturn _ = exitWith (ExitFailure 84)

truc :: IO [Word8]
truc = fileToByteCode =<< (head <$> getArgs)

main :: IO ()
main = truc <&> execFccByteCode <&> execAllByteCodes >>= printVMIO

-- main :: IO ()
-- main = catchIOError (printMaybeError putStrLn =<<
--        (execFccByteCode <$> truc)) ioErrorReturn
