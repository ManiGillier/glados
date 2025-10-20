{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error list
-}

module Error.ErrorList (
   fileFormatError,
   stackError
) where

import Error.MaybeError (ErrorType)

fileFormatError :: ErrorType
fileFormatError = "*** UNROCONIZED FILE FORMAT"

stackError:: ErrorType
stackError = "*** STACK ERROR"
