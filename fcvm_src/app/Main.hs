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
import System.Environment
import System.Exit (exitWith, ExitCode(..))

ioErrorReturn :: IOError -> IO ()
ioErrorReturn _ = exitWith (ExitFailure 84)

truc :: IO ()
truc = do
    letruc <- head <$> getArgs
    withFile letruc ReadMode (hGetContent' fileToByteCode)

main :: IO ()
main = catchIOError truc ioErrorReturn

-- getArgs >>= \args -> withFile (head args) ReadMode fileToByteCode


    -- arg <- head <$> getArgs
    -- if (doesFileExist arg) == return True then fileToByteCode arg
    -- else return 84
