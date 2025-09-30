{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Lexing
-}

module DataStruct.Lexing where

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

data Comparators =
    Equal | Different | Inferior | Superior | InferiorOrEqual | SuperiorOrEqual

data Lexer =
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
    Sayonara

