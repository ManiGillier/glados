{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Lexing
-}

module DataStruct.Lexing(LexedData(..), Comparators(..), Operations(..)) where

data Operations =
    Add |
    Multiply |
    Subtract |
    Divide |
    OpenParenthesis |
    ClosedParenthesis |
    Modulo |
    And |
    Or |
    Not |
    Xor |
    LeftBitshift |
    RightBitshift
    deriving (Show, Eq)

data Comparators =
    Equal | Different | Inferior | Superior | InferiorOrEqual | SuperiorOrEqual
    deriving (Show, Eq)

data LexedData =
    Hi |
    FuncDef |
    FuncType |
    ReturnType |
    Params |
    WithVariables |
    WithParameters |
    DisplayNumber |
    DisplayText |
    DisplayNewLine |
    FuncBody |
    Returns |
    Invoke |
    ReturnVariable |
    Assign |
    If |
    While |
    Else |
    Return |
    EOI |
    Symbol String |
    DuoSymbol String String |
    Number Int |
    Operation Operations |
    Comparator Comparators |
    Sayonara deriving (Show, Eq)
