{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Lexing
-}

module DataStruct.Lexing(LexedData(..), Operations(..),
    UnaryOperations(..), FuncTypes(..), LexedTypes(..), VarValue(..)) where

import Data.Int (Int64)

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
    RightBitshift |
    Equal |
    Different |
    Inferior |
    Superior |
    InferiorOrEqual |
    SuperiorOrEqual
    deriving (Show, Eq)

data LexedTypes =
    LInt | LBoolean | LVoid
    deriving (Show, Eq)

data FuncTypes =
    Main | Function
    deriving (Show, Eq)

data VarValue =
  Bool Bool
  | String String
  | Int Int64
  deriving (Show, Eq)

data LexedData =
    Text String | -- Un texte entre guillemets (pas une variable)
    FuncDef | -- Début de définition d'une fonction
    FuncType FuncTypes | -- Type de fonction Main/Fonction
    ReturnType | -- Type de retour d'une fonction
    WithVariables | -- Variables d'une fonction
    WithParameters | -- Paramètres d'une fonction / Paramètres d'invocation
    Display | -- Afficher
    LexedType LexedTypes | -- Int/Void/Bool/String
    DisplayNewLine | -- Afficher un \n
    FuncBody | -- Début du corps de la fonction
    Returns | -- La fonction retourne..
    Invoke | -- Invoquer
    AssignResultTo | -- assigner la valeur de retour
    OpenParenthesis | -- (
    ClosedParenthesis | -- )
    Assign | -- Assigner une variable à une valeur
    If | -- Si
    While | -- Tant que
    Else | -- Sinon (Pas fait)
    Then | -- Après un if/else
    EndIf | -- Fin d'un if
    EndWhile | -- Fin d'un while
    EndFunction | -- Fin d'une fonction
    Return | -- Retourner une valeur.
    Symbol String | -- Entrée utilisateur
    VariableDeclaration String LexedTypes VarValue | -- Déclaration variable
    Parameter String LexedTypes | -- Déclaration paramètres
    InvokeParameter [LexedData] | -- Computable d'une invocation
    Number Int64 | -- Numéro
    Operation Operations | -- Opération
    UnaryOperation UnaryOperations -- Opération unaire
    deriving (Show, Eq)
