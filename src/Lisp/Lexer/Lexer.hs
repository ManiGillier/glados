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

-- data SExpr = Value !Int
--              | Symbol !String
--              | List ![SExpr]
--              deriving (Show)

import Lisp.Ast.Ast(SExpr(..))
import Text.Read (readMaybe)

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = skipMany (spaceChar)

readSymbol :: Lexer SExpr
readSymbol = do
    _ <- skipWhitespace
    sym <- takeWhile1P Nothing (\c -> not (isSpace c) && c /= '(' && c /= ')')
    _ <- skipWhitespace
    return $ SSymbol sym

readValue :: Lexer SExpr
readValue = do
    _ <- skipWhitespace
    sign <- optional (char '-' <|> char '+')
    word <- takeWhile1P Nothing (\c -> not (isSpace c) && c /= '(' && c /= ')')
    _ <- skipWhitespace
    case readMaybe word of
        Just num -> return $ case sign of
            Just '-' -> SInt (-num)
            _ -> SInt num
        Nothing -> fail "Not a valid integer"

readSList :: Lexer SExpr
readSList = do
    _ <- skipWhitespace
    _ <- char '('
    list <- many readSExpr
    _ <- skipWhitespace
    _ <- char ')'
    _ <- skipWhitespace
    return $ SList list

readSExpr :: Lexer SExpr
readSExpr = try readValue <|> readSList <|> readSymbol

readManySExpr :: Lexer [SExpr]
readManySExpr = many readSExpr
