{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Repl
-}

module Lisp.Shell.Repl (repl) where
import System.IO
import Control.Monad (unless)
import Lisp.Lexer.Lexer ( lexe )
import System.Exit (exitWith, exitSuccess, ExitCode (ExitFailure))
import Text.Megaparsec (ParseErrorBundle, errorBundlePretty)
import Data.Void (Void)
import Lisp.DataStruct.SymbolicExpression (SExpr)
import Lisp.Parser.Parser (parseSExpr)

repl' :: IO ()
repl' = do
    end <- isEOF
    unless end $ do
        content <- getLine
        case content of
            "quit" -> return()
            "q" -> return()
            _ -> putStrLn content >> repl
            --                  put rayane's func before the content in the paranthesis

repl :: IO ()
repl = replSingle ""

manageAfterLexing :: Either (ParseErrorBundle String Void) ([SExpr], String)
  -> IO ()
manageAfterLexing (Left e) = hPutStr stderr (errorBundlePretty e)
  >> exitWith (ExitFailure 84)
manageAfterLexing (Right (value, str)) = print (map parseSExpr value)
  >> replSingle str

replSingle :: String -> IO ()
replSingle str = putStr ("> " ++ str) >> hFlush stdout >> isEOF >>= \ isEof ->
  if isEof then
    return ()
  else
    (fmap (\ str' -> lexe (str ++ str')) getLine) >>= manageAfterLexing
