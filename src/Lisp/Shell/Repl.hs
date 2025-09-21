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
import Lisp.DataStruct.Ast (Ast)
import Lisp.Exec.SymboleTable (SymTable)
import Lisp.Exec.Exec (execLisp)

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

manageAst :: SymTable -> Maybe Ast -> Either String (String, SymTable)
manageAst _ Nothing = Left "Parsing failed."
manageAst table (Just ast) = Right $ execLisp ast table

manageAfterLexing :: SymTable
  -> Either (ParseErrorBundle String Void) ([SExpr], String)
  -> IO ()
manageAfterLexing table (Left e) = hPutStr stderr (errorBundlePretty e)
  >> exitWith (ExitFailure 84)
manageAfterLexing table (Right (value, str)) =
  print expressions
  >> print ast
  >> replSingle str
  where expressions = map parseSExpr value
        ast = map (manageAst table) expressions

replSingle :: String -> IO ()
replSingle str = putStr ("> " ++ str) >> hFlush stdout >> isEOF >>= \ isEof ->
  if isEof then
    return ()
  else
    (fmap (\ str' -> lexe (str ++ str')) getLine) >>= manageAfterLexing []
