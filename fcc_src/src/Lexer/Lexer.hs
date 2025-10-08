{-
-- EPITECH PROJECT, 2025
-- GLaDOS [WSL: Ubuntu-24.04]
-- File description:
-- Lexer
-}

module Lexer.Lexer(skipWhitespace, readWord, readValue, lexSyntaxAndReturn,
    lexStringsWithTokens', lexStringsWithTokens, readAssign, readAssign',
    readCondition, readComputable, readComputables, readIf,
    readParenthesisComputable) where

import Data.Void (Void)

import ApplicativeAddons

import DataStruct.Lexing(LexedData(..), Operations(..), Comparators(..),
    UnaryOperations(..))
import Lexer.Syntax(Syntax(..), assignNameSyntax, assignValueSyntax,
    assignSyntax, assignSyntax', ifSyntax)

import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal, signed)

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = space

readWord :: Lexer LexedData
readWord = Symbol <$> some (noneOf " .,\t\n()")

readValue :: Lexer LexedData
readValue =
    Number
        <$> signed (return ()) decimal
        <* notFollowedBy (noneOf " .,\t\n()")

readUnaryOperation :: Lexer LexedData
readUnaryOperation = UnaryOperation <$> choice [
    BinaryNot <$ string "~",
    Not <$ lexSyntax [SString "non", Space],
    Negate <$ char '-']

readOperation :: Lexer LexedData
readOperation = Operation <$> choice [
    Add      <$ string "plus",
    Subtract <$ string "moins",
    Multiply <$ string "fois",
    Multiply <$ lexSyntax [SString "multiplié", Space, SString "par"],
    Divide   <$ lexSyntax [SString "divisé", Space, SString "par"],
    Modulo <$ string "modulo",
    BinaryAnd <$ try (lexSyntax [SString "et", Space, SString "binaire"]),
    BinaryOr <$ try (lexSyntax [SString "ou", Space, SString "binaire"]),
    Xor <$ try (lexSyntax [SString "ou", Space, SString "exclusif"]),
    Xor <$ string "xor",
    And <$ string "et",
    Or <$ string "ou",
    LeftBitshift <$ try (lexSyntax [SString "décalé", Space,
        SString "binairement", Space, SString "à", Space, SString "gauche"]),
    RightBitshift <$ try (lexSyntax [SString "décalé", Space,
        SString "binairement", Space, SString "à", Space, SString "droite"])]

readComparator :: Lexer LexedData
readComparator = Comparator <$> choice [
    Equal <$ string "égale",
    Different <$ string "différent",
    InferiorOrEqual <$ try (lexSyntax [SString "inférieure", Space,
        SString "ou", Space, SString "égale"]),
    SuperiorOrEqual <$ try (lexSyntax [SString "supérieure", Space,
        SString "ou", Space, SString "égale"]),
    Inferior <$ string "inférieure",
    Superior <$ string "supérieure"]

readParenthesisComputable :: Lexer [LexedData]
readParenthesisComputable =
  (\inner -> [OpenParenthesis] ++ inner ++ [ClosedParenthesis])
    <$> (char '(' *> space *> (readComputableAfterOperation $++
        (concat <$> many readComputable)) <* (space *> char ')'))

readComputableAfterOperationWithUnaryOperation :: Lexer [LexedData]
readComputableAfterOperationWithUnaryOperation =
    (readUnaryOperation <* skipWhitespace) $: ((try (glob readValue) <|>
    try readParenthesisComputable <|> (glob readWord)))

readComputableAfterOperation :: Lexer [LexedData]
readComputableAfterOperation =  try
    readComputableAfterOperationWithUnaryOperation <|> try (glob readValue) <|>
    try readParenthesisComputable <|> (glob readWord)

readComputable :: Lexer [LexedData]
readComputable = try ((space1 *> string "est" *> space1 *> glob readComparator
    <* space <* string "à") $++ (space1 *> readComputableAfterOperation)) <|>
    try (space1 *> readOperation $: (space1 *> readComputableAfterOperation))

readComputables :: Lexer [LexedData]
readComputables = concat <$> (readComputableAfterOperation $:
    (many readComputable))

readCondition :: Lexer [LexedData]
readCondition = readComputables

readEOI :: Lexer Char
readEOI = char '.'

lexSyntax :: [Syntax] -> Lexer ()
lexSyntax [] = return ()
lexSyntax (Word : xs) = readWord >>= \_ -> lexSyntax xs
lexSyntax (Space : xs) = space1 *> lexSyntax xs
lexSyntax (Value : xs) = readValue >>= \_ -> lexSyntax xs
lexSyntax (Condition : xs) = readCondition >>= \_ -> lexSyntax xs
lexSyntax ((SString (x)):xs) = string x *> lexSyntax xs

lexSyntaxAndReturn :: [Syntax] -> a -> Lexer a
lexSyntaxAndReturn [] a = return a
lexSyntaxAndReturn (Word : xs) a = readWord >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Space : xs) a = space1 *> lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Value : xs) a = readValue >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Condition : xs) a = readCondition >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn ((SString (x)):xs) a = string x *> lexSyntaxAndReturn xs a

lexStringsWithTokens' :: [LexedData] -> [Syntax] -> Lexer [LexedData]
lexStringsWithTokens' t [] = return t
lexStringsWithTokens' t (Word : xs) = readWord >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (Space : xs) = space1 *> lexStringsWithTokens' t xs
lexStringsWithTokens' t (Value : xs) = readValue >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (Condition : xs) = readCondition >>= \toAdd ->
    lexStringsWithTokens' (t ++ toAdd) xs
lexStringsWithTokens' t ((SString (x)):xs) = string x *>
    lexStringsWithTokens' t xs

lexStringsWithTokens :: [Syntax] -> Lexer [LexedData]
lexStringsWithTokens toLex = lexStringsWithTokens' [] toLex

readAssign :: Lexer [LexedData]
readAssign = try (lexStringsWithTokens' [Assign] assignSyntax <* readEOI) <|>
    (lexStringsWithTokens' [Assign] assignSyntax' <* readEOI)

readIf :: Lexer [LexedData]
readIf = lexStringsWithTokens' [If] ifSyntax

readAssign' :: Lexer [LexedData]
readAssign' = (\ws1 ws2 -> Assign : ws1 ++ ws2)
    <$> lexStringsWithTokens assignNameSyntax
    <*> lexStringsWithTokens assignValueSyntax
    <* readEOI
