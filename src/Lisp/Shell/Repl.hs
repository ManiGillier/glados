{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Repl
-}

module Lisp.Shell.Repl (repl) where
import System.IO
import Control.Monad (unless)

repl :: IO ()
repl = do
    end <- isEOF
    unless end $ do
        content <- getLine
        case content of
            "quit" -> return()
            "q" -> return()
            otherwise -> putStrLn (content) >> repl
            --                  put rayane's func before the content in the paranthesis
