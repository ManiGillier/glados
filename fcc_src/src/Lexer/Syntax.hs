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
    functionDefinitionEndSyntax, functionTypes, variableTypes,
    invokeSyntax, invokeAssignSyntax, invokeParametersSyntax,
    displaySyntax, displaySyntax', displaySyntax'',
    mainFunctionSyntax, endMainFunctionSyntax, elseSyntax,
    endIfSyntax, endWhileSyntax, endFunctionSyntax,
    returnSyntax, returnSyntax', hiSyntax, equalSyntax,
    equalSyntax', superiorOrEqualSyntax, superiorSyntax, inferiorOrEqualSyntax,
    inferiorSyntax, differentSyntax) where

import DataStruct.Lexing(LexedData(..), LexedTypes(..))

data Syntax =
    Space |
    SString String |
    Word |
    Value |
    Condition |
    ComboWord |
    OptionalComboWord |
    OptionalComboWordsWithValue |
    OptionalComboWords |
    OptionalSpace |
    WordVariableType |
    WordFunctionType |
    MultipleSString [String] |
    MultipleWords |
    MultipleComputables |
    QuotedValue |
    Name |
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
    SString "valeur", Space, Condition]

assignSyntax :: [Syntax]
assignSyntax = [SString "J'aimerais", Space, SString "que", Space, Word,
    Space, SString "prenne", Space, SString "la", Space, SString "valeur",
    Space, Condition]

assignSyntax' :: [Syntax]
assignSyntax' = [Word, Space, SString "prend", Space, SString "la", Space,
    SString "valeur", Space, Condition]

ifConditionSyntax :: [Syntax]
ifConditionSyntax = [SString "Si", Space, Condition, SString ",", Space,
    SString "exécute", Space, SString "le", Space, SString "texte", Space,
    SString ":"]

elseSyntax :: [Syntax]
elseSyntax = [SString ";", Space, SString "sinon,", Space,
    SString "exécute", Space, SString "le", Space, SString "texte", Space,
    SString ":"]

endIfSyntax :: [Syntax]
endIfSyntax = [SString "Merci."]

endWhileSyntax :: [Syntax]
endWhileSyntax = endIfSyntax

endFunctionSyntax :: [Syntax]
endFunctionSyntax = endIfSyntax

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
    OptionalComboWordsWithValue, SString ";", Space]

functionDefinitionEndSyntax :: [Syntax]
functionDefinitionEndSyntax = [SString "représenté", Space, SString "par",
    Space, SString "le", Space, SString "code", Space,
    MultipleSString ["ci-après", "suivant", "ci-dessous"]]

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
    Space, MultipleComputables]

displaySyntax :: [Syntax]
displaySyntax = [SString "Affiche", Space, Condition]

displaySyntax' :: [Syntax]
displaySyntax' = [SString "Affiche", Space, QuotedValue]

displaySyntax'' :: [Syntax]
displaySyntax'' = [SString "Affiche", Space, SString "un", Space,
    SString "retour", Space, SString "à", Space, SString "la", Space,
    SString "ligne"]

mainFunctionSyntax :: [Syntax]
mainFunctionSyntax = [SString "En", Space, SString "sachant", Space,
    SString "que", Space, SString "les", Space, SString "variables", Space,
    SString "principales", Space, SString "sont", Space, SString ":", Space,
    OptionalComboWordsWithValue, SString ";", Space, SString "pourrais-tu",
    Space,
    SString "s'il", Space, SString "te", Space, SString "plaît", Space,
    SString "commencer", Space, SString "la", Space, SString "lecture", Space,
    SString "ici", Space, SString "?"]

endMainFunctionSyntax :: [Syntax]
endMainFunctionSyntax = [SString "Merci d'avance,", Space,
    SString "Cordialement,", Space, Name, Name]

returnSyntax :: [Syntax]
returnSyntax = [SString "Enfin,", Space, SString "renvoie", Space, Condition]

returnSyntax' :: [Syntax]
returnSyntax' = [SString "Enfin,", Space, SString "sors", Space,
    SString "du", Space, SString "bloc"]

hiSyntax :: [Syntax]
hiSyntax = [SString "Bonjour,"]

equalSyntax :: [Syntax]
equalSyntax = [SString "est", Space, SString "égale", Space, SString "à"]

differentSyntax :: [Syntax]
differentSyntax = [SString "est", Space, SString "différent", Space,
    SString "de"]

inferiorOrEqualSyntax :: [Syntax]
inferiorOrEqualSyntax = [SString "est", Space, SString "inférieure", Space,
        SString "ou", Space, SString "égale", Space, SString "à"]

superiorOrEqualSyntax :: [Syntax]
superiorOrEqualSyntax = [SString "est", Space, SString "supérieure", Space,
        SString "ou", Space, SString "égale", Space, SString "à"]

inferiorSyntax :: [Syntax]
inferiorSyntax = [SString "est", Space, SString "inférieure", Space,
    SString "à"]

superiorSyntax :: [Syntax]
superiorSyntax = [SString "est", Space, SString "supérieure", Space,
    SString "à"]

equalSyntax' :: [Syntax]
equalSyntax' = [SString "est"]
