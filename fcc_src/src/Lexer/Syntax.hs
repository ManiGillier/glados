{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Syntax
-}

module Lexer.Syntax(Syntax(..), assignNameSyntax, assignValueSyntax,
    assignSyntax, assignSyntax', ifConditionSyntax,
    whileConditionSyntax, functionDefinitionSyntax,
    functionDefinitionSyntax') where
import DataStruct.Lexing(LexedData(..))

data Syntax =
    Space |
    SString String |
    Word |
    Value |
    Condition |
    ComboWord |
    OptionalComboWord |
    OptionalComboWords |
    OptionalSpace |
    Placeholder LexedData
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

ifConditionSyntax :: [Syntax]
ifConditionSyntax = [SString "Si", Space, Condition, SString ",", Space,
    SString "exécute", Space, SString "le", Space, SString "texte", Space,
    SString ":"]

whileConditionSyntax :: [Syntax]
whileConditionSyntax = [SString "Tant", Space, SString "que", Space, Condition,
    Space, SString "exécute", Space, SString "le", Space, SString "code",
    Space, SString "ci-après", Space, SString ":"]

functionDefinitionSyntax :: [Syntax]
functionDefinitionSyntax = [SString "J'aimerais", Space, SString "définir",
    Space, SString "le", Space, SString "bloc", Space, SString "répondant",
    Space, SString "au", Space, SString "nom", Space, SString "de", Space,
    Word, SString ",", Space, SString "de", Space, SString "type", Space,
    SString "de", Space, SString "retour", Space, Placeholder ReturnType, Word,
    SString ",", Space, SString "nécessitant", Space, SString "comme", Space,
    SString "entrée", Space, SString ":", Placeholder WithParameters, Space,
    OptionalComboWords, SString ";", Space, SString "contenant", Space,
    SString "les", Space, SString "variables", Space, SString ":",
    Placeholder WithVariables, Space, OptionalComboWords, SString ";", Space,
    SString "représenté", Space, SString "par", Space, SString "le",
    Space, SString "code", Space, SString "suivant"]

functionDefinitionSyntax' :: [Syntax]
functionDefinitionSyntax' = [SString "J'aimerais", Space, SString "définir",
    Space, SString "le", Space, SString "bloc", Space, SString "répondant",
    Space, SString "au", Space, SString "nom", Space, SString "de", Space,
    Word, SString ",", Space, SString "de", Space, SString "type", Space,
    SString "de", Space, SString "retour", Space, Placeholder ReturnType, Word,
    SString ",", Space, SString "nécessitant", Space, SString "comme", Space,
    SString "entrée", Space, SString ":", Placeholder WithParameters, Space,
    OptionalComboWords, SString ";", Space, SString "contenant", Space,
    SString "les", Space, SString "variables", Space, SString ":",
    Placeholder WithVariables, Space, OptionalComboWords, SString ";", Space,
    SString "représenté", Space, SString "par", Space, SString "le",
    Space, SString "code", Space, SString "suivant", Placeholder Returns,
    Space, SString "retournant", Space, Word]
