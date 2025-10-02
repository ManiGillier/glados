{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Syntax
-}

module Lexer.Syntax(assignNameSyntax, assignValueSyntax, assignSyntax, assignSyntax', ifSyntax) where

assignNameSyntax :: [String]
assignNameSyntax = words "J'aimerais que <S>"

assignValueSyntax :: [String]
assignValueSyntax = words "prenne la valeur <V>"

assignSyntax :: [String]
assignSyntax = words "J'aimerais que <S> prenne la valeur <V>"

assignSyntax' :: [String]
assignSyntax' = words "<S> prend la valeur <V>"

ifSyntax :: [String]
ifSyntax = words "Si <S>, exécute le texte :"
