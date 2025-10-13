{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Lexing
-}

module DataStruct.Lexing(LexedData(..), Comparators(..), Operations(..),
    UnaryOperations(..), FuncTypes(..)) where

data UnaryOperations =
    Not |
    BinaryNot |
    Negate
    deriving (Show, Eq)

data Operations =
    Add |
    Multiply |
    Subtract |
    Divide |
    Modulo |
    BinaryAnd |
    BinaryOr |
    And |
    Or |
    Xor |
    LeftBitshift |
    RightBitshift
    deriving (Show, Eq)

data Comparators =
    Equal | Different | Inferior | Superior | InferiorOrEqual | SuperiorOrEqual
    deriving (Show, Eq)

data FuncTypes =
    Main | Function
    deriving (Show, Eq)

data LexedData =
    Hi |
    FuncDef |
    FuncType FuncTypes |
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
    OpenParenthesis |
    ClosedParenthesis |
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
    UnaryOperation UnaryOperations |
    Comparator Comparators |
    Sayonara deriving (Show, Eq)
