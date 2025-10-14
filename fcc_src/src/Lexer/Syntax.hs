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
    functionDefinitionReturnsVariableSyntax, functionTypes, variableTypes,
    invokeSyntax, invokeAssignSyntax, invokeParametersSyntax) where
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
    WordVariableType |
    WordFunctionType |
    MultipleSString [String] |
    MultipleWords |
    Placeholder LexedData
    deriving (Show, Eq)

fcIntType :: [Syntax]
fcIntType = [SString "entier", Space, SString "naturel"]

fcBoolType :: [Syntax]
fcBoolType = [SString "booléen"]

fcStringType :: [Syntax]
fcStringType = [SString "chaîne", Space, SString "de", Space,
    SString "caractères"]

fcVoidType :: [Syntax]
fcVoidType = [SString "nul"]

variableTypes :: [([Syntax], LexedData)]
variableTypes = [(fcIntType, LexedType LInt), (fcBoolType, LexedType LBoolean),
    (fcStringType, LexedType LString)]

functionTypes :: [([Syntax], LexedData)]
functionTypes = variableTypes ++ [(fcVoidType, LexedType LVoid)]

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
    Space, SString "de", Space, SString "retour", Space, WordFunctionType,
    SString ",", Space]

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
functionDefinitionReturnsVariableSyntax = [SString ",", Space,
    SString "retournant", Space, Word]

invokeSyntax :: [Syntax]
invokeSyntax = [SString "J'invoque", Space, SString "le", Space,
    SString "bloc", Space, Word]

invokeAssignSyntax :: [Syntax]
invokeAssignSyntax = [SString ",", Space, SString "et", Space,
    SString "j'assigne", Space, SString "la", Space, SString "valeur",
    Space, SString "de", Space, SString "retour", Space, SString "à",
    Space, SString "la", Space, SString "variable", Space, Word]

invokeParametersSyntax :: [Syntax]
invokeParametersSyntax = [SString ",", Space, SString "avec les paramètres",
    Space, MultipleWords]
