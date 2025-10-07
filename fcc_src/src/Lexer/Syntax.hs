{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Syntax
-}

module Lexer.Syntax(Syntax(..), assignNameSyntax, assignValueSyntax,
    assignSyntax, assignSyntax', ifSyntax) where

data Syntax =
    Space |
    SString String |
    Word |
    Value |
    Condition
    deriving (Show, Eq)

assignNameSyntax :: [Syntax]
assignNameSyntax = [SString "J'aimerais", Space, SString "que", Space, Word]

assignValueSyntax :: [Syntax]
assignValueSyntax = [Space, SString "prenne", Space, SString "la", Space,
    SString "valeur", Space, Value]

assignSyntax :: [Syntax]
assignSyntax = [SString "J'aimerais", Space, SString "que", Space, Word,
    Space, SString "prenne", Space, SString "la", Space, SString "valeur",
    Space, Value]

assignSyntax' :: [Syntax]
assignSyntax' = [Word, Space, SString "prend", Space, SString "la", Space,
    SString "valeur", Space, Value]

ifSyntax :: [Syntax]
ifSyntax = [SString "Si", Space, Condition, SString ",", Space,
    SString "exécute", Space, SString "le", Space, SString "texte", Space,
    SString ":"]
