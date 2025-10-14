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
    LInt | LBoolean | LString | LVoid
    deriving (Show, Eq)

data Comparators =
    Equal | Different | Inferior | Superior | InferiorOrEqual | SuperiorOrEqual
    deriving (Show, Eq)

data FuncTypes =
    Main | Function
    deriving (Show, Eq)

data LexedData =
    Hi | -- Bonjour
    FuncDef | -- Début de définition d'une fonction
    FuncType FuncTypes | -- Type de fonction Main/Fonction
    ReturnType | -- Type de retour d'une fonction
    WithVariables | -- Variables d'une fonction
    WithParameters | -- Paramètres d'une fonction / Paramètres d'invocation
    DisplayNumber | -- Afficher un nombre
    DisplayText | -- Afficher un texte
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
    Return | -- Retourner une valeur.
    Symbol String | -- Entrée utilisateur
    SymbolWithType String LexedTypes | -- Combo entrée utilisateur et type
    Number Int | -- Numéro
    Operation Operations | -- Opération 
    UnaryOperation UnaryOperations | -- Opération unaire
    Comparator Comparators | -- Comparateur
    Sayonara deriving (Show, Eq) -- Cordialement

