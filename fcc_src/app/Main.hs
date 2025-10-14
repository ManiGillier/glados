{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc main
-}

module Main (main) where

import ArgParser (debugArgs, getMyArgs)

main :: IO ()
main = getMyArgs >>= debugArgs
