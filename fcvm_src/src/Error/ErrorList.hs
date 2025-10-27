{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error list
-}

module Error.ErrorList (
   fileFormatError,
   stackError
   ,divError
   ,stackOverFlowError
) where

import Error.MaybeError (ErrorType)

fileFormatError :: String
fileFormatError = "*** UNROCONIZED FILE FORMAT"

stackOverFlowError :: String
stackOverFlowError = "*** STACK OVERFLOW"

stackError:: ErrorType
stackError = "*** STACK ERROR"

divError:: ErrorType
divError = "*** 0 CAN'T BE USE in this operation"
