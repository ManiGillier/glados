{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Lexing
-}

module DataStruct.Lexing(LexedData(..), Comparators(..), Operations(..),
    UnaryOperations(..), FuncTypes(..), LexedTypes(..)) where

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

data LexedTypes =
    LInt | LBoolean | LString
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
    LexedType LexedTypes |
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
    SymbolWithType String LexedTypes |
    Number Int |
    Operation Operations |
    UnaryOperation UnaryOperations |
    Comparator Comparators |
    Sayonara deriving (Show, Eq)
