{-
-- EPITECH PROJECT, 2025
-- GLaDOS [WSL: Ubuntu-24.04]
-- File description:
-- Lexer
-}

module Lexer.Lexer(skipWhitespace, readWord, readValue, lexStrings,
    lexStringsWithTokens', lexStringsWithTokens, readAssign, readAssign') where

import Data.Void (Void)
import DataStruct.Lexing(SExpr(..))
import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal, signed)

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = space

readWord :: Lexer SExpr
readWord = Symbol <$> some (noneOf " .\t\n") <* space

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
lexStrings (x:xs) a = skipWhitespace *> string x *> skipWhitespace *>
    lexStrings xs a

lexStringsWithTokens' :: [SExpr] -> [String] -> Lexer [SExpr]
lexStringsWithTokens' t [] = return t
lexStringsWithTokens' t ("<S>": xs) = readWord >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t ("<V>": xs) = readValue >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (x:xs) = skipWhitespace *> string x *>
    skipWhitespace *> lexStringsWithTokens' t xs

lexStringsWithTokens :: [String] -> Lexer [SExpr]
lexStringsWithTokens toLex = lexStringsWithTokens' [] toLex

assignName :: [String]
assignName = words "J'aimerais que <S>"

assignValue :: [String]
assignValue = words "prenne la valeur <V>"

assignSentence :: [String]
assignSentence = words "J'aimerais que <S> prenne la valeur <V>"

readAssign :: Lexer [SExpr]
readAssign = lexStringsWithTokens' [Assign] assignSentence <* readEOI

readAssign' :: Lexer [SExpr]
readAssign' = (\ws1 ws2 -> Assign : ws1 ++ ws2)
    <$> lexStringsWithTokens assignName
    <*> lexStringsWithTokens assignValue
    <* readEOI
