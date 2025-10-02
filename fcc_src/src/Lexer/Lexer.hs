{-
-- EPITECH PROJECT, 2025
-- GLaDOS [WSL: Ubuntu-24.04]
-- File description:
-- Lexer
-}

module Lexer.Lexer(skipWhitespace, readWord, readValue, lexStrings,
    lexStringsWithTokens', lexStringsWithTokens, readAssign, readAssign', readCondition) where

import Data.Void (Void)

import DataStruct.Lexing(SExpr(..))
import Lexer.Syntax(assignNameSyntax, assignValueSyntax, assignSyntax, assignSyntax', ifSyntax)

import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal, signed)


type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = space

readWord :: Lexer SExpr
readWord = Symbol <$> some (noneOf " .\t\n,") <* skipWhitespace

readValue :: Lexer SExpr
readValue =
    Number
        <$> signed (return ()) decimal
        <* notFollowedBy (noneOf " .\t\n()")
        <* skipWhitespace

readEOI :: Lexer Char
readEOI = char '.'

lexStrings :: [String] -> a -> Lexer a
lexStrings [] a = return a
lexStrings (x:xs) a = skipWhitespace *> string x *> space1 *> skipWhitespace *>
    lexStrings xs a

lexStringsWithTokens' :: [SExpr] -> [String] -> Lexer [SExpr]
lexStringsWithTokens' t [] = return t
lexStringsWithTokens' t ("<S>": xs) = readWord >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t ("<S>,": xs) = readWord >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t ("<V>": xs) = readValue >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t [x] = skipWhitespace *> string x
    *> skipWhitespace *> lexStringsWithTokens' t []
lexStringsWithTokens' t (x:xs) = skipWhitespace *> string x *> space1 *>
    skipWhitespace *> lexStringsWithTokens' t xs

lexStringsWithTokens :: [String] -> Lexer [SExpr]
lexStringsWithTokens toLex = lexStringsWithTokens' [] toLex

readAssign :: Lexer [SExpr]
readAssign = try (lexStringsWithTokens' [Assign] assignSyntax <* readEOI) <|>
    (lexStringsWithTokens' [Assign] assignSyntax' <* readEOI)

readCondition :: Lexer [SExpr]
readCondition = do
    m <- lexStringsWithTokens' [If] ifSyntax
    return m

readAssign' :: Lexer [SExpr]
readAssign' = (\ws1 ws2 -> Assign : ws1 ++ ws2)
    <$> lexStringsWithTokens assignNameSyntax
    <*> lexStringsWithTokens assignValueSyntax
    <* readEOI
