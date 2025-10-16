{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc main
-}

module Main (main) where

import ArgParser (debugArgs, getMyArgs)
import Error.MaybeError (printMaybeError)

main :: IO ()
main = getMyArgs >>= (printMaybeError debugArgs)
