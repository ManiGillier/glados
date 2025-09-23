{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Repl
-}

module Lisp.Shell.Repl (repl) where

import Data.Void (Void)
import Lisp.DataStruct.Ast (Ast)
import Lisp.DataStruct.SymbolicExpression (SExpr)
import Lisp.Exec.Exec (execLisp)
import Lisp.Exec.SymboleTable (SymTable)
import Lisp.Lexer.Lexer (lexe)
import Lisp.Parser.Parser (parseSExpr)
import System.Exit (ExitCode (ExitFailure), exitWith)
import System.IO
import Text.Megaparsec (ParseErrorBundle, errorBundlePretty)
import Error.MaybeError (MaybeError(..))

data Storage = Storage
    { ibuf :: !String
    , symTable :: !(SymTable, [String])
    }

repl :: IO ()
repl = replSingle $ Storage "" ([], [])

execFold :: MaybeError (SymTable, [String]) -> Ast -> MaybeError (SymTable, [String])
execFold (Correct (table', str')) ast =
  case str of
    Correct str'' -> Correct (table, str'' : str')
    Error t e -> Error t e
  where
    (str, table) = execLisp ast table'
execFold (Error t e) _ = Error t e

manageAfterLexing :: Storage
    -> Either (ParseErrorBundle String Void) ([SExpr], String)
    -> IO ()
manageAfterLexing _ (Left e) =
    hPutStr stderr (errorBundlePretty e)
        >> exitWith (ExitFailure 84)
manageAfterLexing s (Right (value, str)) = case final of
  Correct (Correct (table, result)) ->
    mapM putStrLn (filter (\str' -> not $ null str') result)
    >> replSingle (s{ibuf = str, symTable = (table, [])})
  Correct err -> hPutStrLn stderr (show err)
    >> exitWith (ExitFailure 84)
  err -> hPutStrLn stderr (show err) >> exitWith (ExitFailure 84)
  where
    expressions = sequence $ map parseSExpr value
    final = foldl' execFold (Correct $ symTable s) <$> expressions

replSingle :: Storage -> IO ()
replSingle s =
    putStr ("> " ++ ibuf s) >> hFlush stdout >> isEOF >>= \isEof ->
        if isEof then
            return ()
        else
            (fmap (\str' -> lexe (ibuf s ++ 
                str')) getLine) >>= manageAfterLexing s
