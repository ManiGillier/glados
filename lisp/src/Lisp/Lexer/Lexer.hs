{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Lexer
--}

module Lisp.Lexer.Lexer (lexe)
where

import Data.Void (Void)
import Lisp.DataStruct.SymbolicExpression (SExpr (..))
import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal, signed, symbol)

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = space

-- readSymbol' :: Lexer SExpr
-- readSymbol' = do
--     _ <- skipWhitespace
--     sym <- takeWhile1P Nothing (\c -> not (isSpace c) && c /= '(' && c /= ')')
--     _ <- skipWhitespace
--     return $ Symbol sym

readSymbol :: Lexer SExpr
readSymbol =
    Symbol
        <$> some (noneOf " \t\n()")
        <* space

-- readValue' :: Lexer SExpr
-- readValue' = do
--     _ <- skipWhitespace
--     sign <- optional (char '-' <|> char '+')
--     word <- takeWhile1P Nothing (\c -> not (isSpace c) && c /= '(' && c /= ')')
--     _ <- skipWhitespace
--     case readMaybe word of
--         Just num -> return $ case sign of
--             Just '-' -> Value (-num)
--             Just _ -> Value num
--             Nothing -> Value num
--         Nothing -> fail "Not a valid integer"

readValue :: Lexer SExpr
readValue =
    Value
        <$> signed (return ()) decimal
        <* notFollowedBy (noneOf " \t\n()")
        <* skipWhitespace

-- readSList' :: Lexer SExpr
-- readSList' = do
--     _ <- skipWhitespace
--     _ <- char '('
--     list <- many readSExpr
--     _ <- skipWhitespace
--     _ <- char ')'
--     _ <- skipWhitespace
--     return $ List list

readSList :: Lexer SExpr
readSList =
    List
        <$> between (symbol (return ()) "(")
            (symbol (return ()) ")") (readManySExpr)
        <* space

readSExpr :: Lexer SExpr
readSExpr = try readSList <|> try readValue <|> readSymbol

readManySExpr :: Lexer [SExpr]
readManySExpr = many readSExpr

startReadManySExpr :: Lexer [SExpr]
startReadManySExpr = notFollowedBy (char ')') 
    *> readManySExpr <* notFollowedBy (char ')')

lexe :: String -> Either (ParseErrorBundle String Void) ([SExpr], String)
lexe = parse ((,) <$> startReadManySExpr <*> getInput) ""
