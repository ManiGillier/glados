{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcvm main
-}

module Main (main) where

import Lib
import FileOpening.FileToBytecode
import System.IO
import System.IO.Error
import Prelude
import System.Environment
import Data.Word
import System.Exit (exitWith, ExitCode(..))

ioErrorReturn :: IOError -> IO ()
ioErrorReturn _ = exitWith (ExitFailure 84)

truc :: IO [Word8]
truc = fileToByteCode =<< (head <$> getArgs)

main :: IO ()
main = catchIOError (truc >>= print) ioErrorReturn

-- getArgs >>= \args -> withFile (head args) ReadMode fileToByteCode


    -- arg <- head <$> getArgs
    -- if (doesFileExist arg) == return True then fileToByteCode arg
    -- else return 84
