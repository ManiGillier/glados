{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- map
-}

module Map.Map (Map, get, set, merge, contains) where

type Map a b = [(a, b)]

contains :: Eq a => Map a b -> a -> Bool
contains [] _ = False
contains ((x,_):xs) a
  | x == a = True
  | otherwise = contains xs a

get :: Eq a => Map a b -> a -> Maybe b
get [] _ = Nothing
get ((a',b'):xs) a
  | a' == a = Just b'
  | otherwise = get xs a

set :: Eq a => Map a b -> a -> b -> Map a b
set [] a b = [(a, b)]
set ((a',b'):xs) a b
  | a' == a = (a',b):xs
  | otherwise = (a',b') : (set xs a b)

merge :: Eq a => Map a b -> Map a b -> Map a b
merge m1 [] = m1
merge m1 ((a,b):xs) = merge (set m1 a b) xs
