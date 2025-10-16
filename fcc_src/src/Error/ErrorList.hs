{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error list
-}

module Error.ErrorList
  ( ukVarErr
  , supportErr
  , alreadyDefVarErr
  , alreadyDefFuncErr
  , noMainErr
  , unsupportedLanguage
) where

import Error.MaybeError (ErrorType)

ukVarErr :: ErrorType
ukVarErr = "Unknown variable"

supportErr :: ErrorType
supportErr = "Unsupported type"

alreadyDefVarErr :: ErrorType
alreadyDefVarErr = "Redefinition of variable"

alreadyDefFuncErr :: ErrorType
alreadyDefFuncErr = "Redefinition of function"

noMainErr :: ErrorType
noMainErr = "Undefined reference of main"

unsupportedLanguage :: ErrorType
unsupportedLanguage = "File extension is from an unsupported language"
