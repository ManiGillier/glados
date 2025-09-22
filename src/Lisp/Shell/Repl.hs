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

data Storage = Storage
    { ibuf :: !String
    , symTable :: !(SymTable, [String])
    }

-- repl' :: IO ()
-- repl' = do
--     end <- isEOF
--     unless end $ do
--         content <- getLine
--         case content of
--             "quit" -> return ()
--             "q" -> return ()
--             _ -> putStrLn content >> repl

--                  put rayane's func before the content in the paranthesis

repl :: IO ()
repl = replSingle $ Storage "" ([], [])

execFold :: (SymTable, [String]) -> Ast -> (SymTable, [String])
execFold (table', str') ast = (table, str : str')
  where
    (str, table) = execLisp ast table'

manageAfterLexing ::
    Storage ->
    Either (ParseErrorBundle String Void) ([SExpr], String) ->
    IO ()
manageAfterLexing _ (Left e) =
    hPutStr stderr (errorBundlePretty e)
        >> exitWith (ExitFailure 84)
manageAfterLexing s (Right (value, str)) =
    print value
        >> print expressions
        >> print final
        >> case final of
            Just (table, result) ->
                mapM putStrLn (filter (\str' -> not $ null str') result)
                    >> replSingle (s{ibuf = str, symTable = (table, [])})
            Nothing -> hPutStrLn stderr "Parsing error." >> exitWith (ExitFailure 84)
  where
    expressions = sequence $ map parseSExpr value
    final = foldl' execFold (symTable s) <$> expressions

replSingle :: Storage -> IO ()
replSingle s =
    putStr ("> " ++ ibuf s) >> hFlush stdout >> isEOF >>= \isEof ->
        if isEof
            then
                return ()
            else
                (fmap (\str' -> lexe (ibuf s ++ str')) getLine) >>= manageAfterLexing s
