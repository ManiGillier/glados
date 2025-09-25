{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error list
-}

module Error.ErrorList (
  lambdaArgError
  , invalidRestrictedKeywordUse
  , parsingError
) where

import Error.MaybeError (ErrorType)

lambdaArgError :: ErrorType
lambdaArgError = "*** LAMBDA ARG ERROR"

invalidRestrictedKeywordUse :: ErrorType
invalidRestrictedKeywordUse = "*** INVALID USE OF RESTRICTED KEYWORD"

parsingError :: ErrorType
parsingError = "*** PARSING ERROR"
