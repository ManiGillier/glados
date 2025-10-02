{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc Applicative addons
-}

module ApplicativeAddons
    ( glob
    , ($++)
    , ($:)
    ) where
import Data.List (singleton)

infixl 5 $++
infixl 5 $:

glob :: Applicative f => f a -> f [a]
glob = fmap singleton

($++) :: Applicative f => f [a] -> f [a] -> f [a]
x $++ y = liftA2 (++) x y

($:) :: Applicative f => f a -> f [a] -> f [a]
x $: xs = liftA2 (:) x xs
