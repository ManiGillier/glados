{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Lexer
--}

module Lisp.Lexer.Lexer (skipWhitespace, readSymbol, readValue, readSList, readSExpr,
    readManySExpr)
    where

import Text.Megaparsec
import Text.Megaparsec.Char
import Data.Void
import Data.Char(isSpace)
import Lisp.DataStruct.SymbolicExpression(SExpr(..))
import Text.Read (readMaybe)

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = skipMany (spaceChar)

readSymbol :: Lexer SExpr
readSymbol = do
    _ <- skipWhitespace
    sym <- takeWhile1P Nothing (\c -> not (isSpace c) && c /= '(' && c /= ')')
    _ <- skipWhitespace
    return $ Symbol sym

readValue :: Lexer SExpr
readValue = do
    _ <- skipWhitespace
    sign <- optional (char '-' <|> char '+')
    word <- takeWhile1P Nothing (\c -> not (isSpace c) && c /= '(' && c /= ')')
    _ <- skipWhitespace
    case readMaybe word of
        Just num -> return $ case sign of
            Just '-' -> Value (-num)
            _ -> Value num
        Nothing -> fail "Not a valid integer"

readSList :: Lexer SExpr
readSList = do
    _ <- skipWhitespace
    _ <- char '('
    list <- many readSExpr
    _ <- skipWhitespace
    _ <- char ')'
    _ <- skipWhitespace
    return $ List list

readSExpr :: Lexer SExpr
readSExpr = try readValue <|> readSList <|> readSymbol

readManySExpr :: Lexer [SExpr]
readManySExpr = many readSExpr
