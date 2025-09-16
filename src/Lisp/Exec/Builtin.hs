{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Builtin 
-}

module Lisp.Exec.Builtin (equal,
                    infsign,
                    add,
                    sub,
                    mul,
                    safeDiv,
                    safeMod)
    where

-- eq? 
equal :: Int -> Int -> Bool
equal = (==)

-- <
infsign :: Int -> Int -> Bool
infsign = (<)

-- + 
add :: Int -> Int -> Int
add = (+)

-- -
sub :: Int -> Int -> Int
sub = (-)

-- *
mul :: Int -> Int -> Int 
mul = (*)

-- div
safeDiv :: Int -> Int -> Int
safeDiv = Prelude.div

-- mod
safeMod :: Int -> Int -> Int
safeMod = Prelude.mod
