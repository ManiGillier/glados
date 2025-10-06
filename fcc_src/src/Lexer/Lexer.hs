{-
-- EPITECH PROJECT, 2025
-- GLaDOS [WSL: Ubuntu-24.04]
-- File description:
-- Lexer
-}

module Lexer.Lexer(skipWhitespace, readWord, readValue, lexStrings,
    lexStringsWithTokens', lexStringsWithTokens, readAssign, readAssign', readCondition,
    readComputable, readComputables) where

import Data.Void (Void)

import ApplicativeAddons

import DataStruct.Lexing(LexedData(..), Operations(..), Comparators(..))
import Lexer.Syntax(assignNameSyntax, assignValueSyntax, assignSyntax, assignSyntax', ifSyntax)

import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal, signed)

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = space

readWord :: Lexer LexedData
readWord = Symbol <$> some (noneOf " .\t\n,") <* skipWhitespace

readValue :: Lexer LexedData
readValue =
    Number
        <$> signed (return ()) decimal
        <* notFollowedBy (noneOf " .\t\n()")
        <* skipWhitespace

readOperation :: Lexer LexedData
readOperation = Operation <$> choice [
    Add      <$ string "plus",
    Subtract <$ string "moins",
    Multiply <$ string "fois",
    Multiply <$ string "multiplié par",
    Divide   <$ string "divisé par",
    Modulo <$ string "modulo"]

readComparator :: Lexer LexedData
readComparator = Comparator <$> choice [
    Equal <$ string "=="]

readComputableAfterOperation :: Lexer LexedData
readComputableAfterOperation = try readValue <|> readWord

readComputable :: Lexer [LexedData]
readComputable = try (readOperation $: (space1 *> glob readComputableAfterOperation))

readComputables :: Lexer [LexedData]
readComputables = concat <$> (glob readComputableAfterOperation $: many readComputable)

readCondition :: Lexer [LexedData]
readCondition = readComputables $++ (glob readComparator) $++ (space1 *> readComputables)

readEOI :: Lexer Char
readEOI = char '.'

lexStrings :: [String] -> a -> Lexer a
lexStrings [] a = return a
lexStrings (x:xs) a = skipWhitespace *> string x *> space1 *> skipWhitespace *>
    lexStrings xs a

lexStringsWithTokens' :: [LexedData] -> [String] -> Lexer [LexedData]
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

lexStringsWithTokens :: [String] -> Lexer [LexedData]
lexStringsWithTokens toLex = lexStringsWithTokens' [] toLex

readAssign :: Lexer [LexedData]
readAssign = try (lexStringsWithTokens' [Assign] assignSyntax <* readEOI) <|>
    (lexStringsWithTokens' [Assign] assignSyntax' <* readEOI)

readAssign' :: Lexer [LexedData]
readAssign' = (\ws1 ws2 -> Assign : ws1 ++ ws2)
    <$> lexStringsWithTokens assignNameSyntax
    <*> lexStringsWithTokens assignValueSyntax
    <* readEOI
