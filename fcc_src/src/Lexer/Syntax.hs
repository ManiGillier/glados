{-
-- EPITECH PROJECT, 2025
-- fcc_src [WSL: Ubuntu-24.04]
-- File description:
-- Syntax
-}

module Lexer.Syntax(Syntax(..), assignNameSyntax, assignValueSyntax,
    assignSyntax, assignSyntax', ifConditionSyntax,
    whileConditionSyntax, functionDefinitionNameSyntax,
    functionDefinitionReturnTypeSyntax,
    functionDefinitionParametersSyntax,
    functionDefinitionWithVariablesSyntax,
    functionDefinitionEndSyntax,
    functionDefinitionReturnsVariableSyntax, fcTypes) where
import DataStruct.Lexing(LexedData(..), LexedTypes(..))

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
    WordType |
    MultipleSString [String] |
    Placeholder LexedData
    deriving (Show, Eq)

fcIntType :: [Syntax]
fcIntType = [SString "entier", Space, SString "naturel"]

fcBoolType :: [Syntax]
fcBoolType = [SString "booléen"]

fcStringType :: [Syntax]
fcStringType = [SString "chaîne", Space, SString "de", Space,
    SString "caractères"]

fcTypes :: [([Syntax], LexedData)]
fcTypes = [(fcIntType, LexedType LInt), (fcBoolType, LexedType LBoolean),
    (fcStringType, LexedType LString)]

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

functionDefinitionNameSyntax :: [Syntax]
functionDefinitionNameSyntax = [SString "J'aimerais", Space,
    SString "définir", Space, SString "le", Space, SString "bloc", Space,
    SString "répondant", Space, SString "au", Space, SString "nom", Space,
    SString "de", Space, Word, SString ",", Space]

functionDefinitionReturnTypeSyntax :: [Syntax]
functionDefinitionReturnTypeSyntax = [SString "de", Space, SString "type",
    Space, SString "de", Space, SString "retour", Space, WordType, SString ",",
    Space]

functionDefinitionParametersSyntax :: [Syntax]
functionDefinitionParametersSyntax = [SString "nécessitant", Space,
    SString "comme", Space, SString "entrée", Space, SString ":", Space,
    OptionalComboWords, SString ";", Space]

functionDefinitionWithVariablesSyntax :: [Syntax]
functionDefinitionWithVariablesSyntax = [SString "contenant", Space,
    SString "les", Space, SString "variables", Space, SString ":", Space,
    OptionalComboWords, SString ";", Space]

functionDefinitionEndSyntax :: [Syntax]
functionDefinitionEndSyntax = [SString "représenté", Space, SString "par",
    Space, SString "le", Space, SString "code", Space,
    MultipleSString ["ci-après", "suivant", "ci-dessous"]]

functionDefinitionReturnsVariableSyntax :: [Syntax]
functionDefinitionReturnsVariableSyntax = [SString ",", Space, SString "retournant", Space,
    Word]
