{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- error list
-}

module Error.ErrorList (
   fileFormatError 
) where

import Error.MaybeError (ErrorType)

fileFormatError :: ErrorType
fileFormatError = "*** UNROCONIZED FILE FORMAT"
