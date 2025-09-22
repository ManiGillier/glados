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

execFold :: (SymTable, [String]) -> Ast -> (SymTable, [String])
execFold (table', str') ast =
  case str of
    Correct str'' -> (table, str'' : str')
    Error t e -> (table, (t ++ e) : str')
  where
    (str, table) = execLisp ast table'

manageAfterLexing :: Storage
    -> Either (ParseErrorBundle String Void) ([SExpr], String)
    -> IO ()
manageAfterLexing _ (Left e) =
    hPutStr stderr (errorBundlePretty e)
        >> exitWith (ExitFailure 84)
manageAfterLexing s (Right (value, str)) =
    case final of
        Correct (table, result) ->
            mapM putStrLn (filter (\str' -> not $ null str') result)
                >> replSingle (s{ibuf = str, symTable = (table, [])})
        err -> hPutStrLn stderr (show err) >> exitWith (ExitFailure 84)
  where
    expressions = sequence $ map parseSExpr value
    final = foldl' execFold (symTable s) <$> expressions

replSingle :: Storage -> IO ()
replSingle s =
    putStr ("> " ++ ibuf s) >> hFlush stdout >> isEOF >>= \isEof ->
        if isEof then
            return ()
        else
            (fmap (\str' -> lexe (ibuf s ++ str')) getLine) >>= manageAfterLexing s
