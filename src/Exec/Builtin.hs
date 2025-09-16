{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Builtin 
-}

module Exec.Builtin (equal,
                    infsign,
                    add,
                    sub,
                    mul,
                    safeDiv,
                    safeMod)
    where

-- eq? 
equal :: Int -> Int -> Bool
equal x y = x == y

-- <
infsign :: Int -> Int -> Bool
infsign x y = x < y

-- + 
add :: Int -> Int -> Int
add x y = x + y

-- -
sub :: Int -> Int -> Int
sub x y = x - y

-- *
mul :: Int -> Int -> Int 
mul x y = x * y

-- div
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv x y = Just (x `div` y)

-- mod
safeMod :: Int -> Int -> Maybe Int
safeMod _ 0 = Nothing
safeMod x y = Just (x `mod` y)
