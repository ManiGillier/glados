{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- compiler variable
-}

module Tests.Compiler.Variable ( variableTest ) where
import Test.HUnit
import Compiler.Variable (getStorageSize)

variableTest :: Test
variableTest = TestList $
  [ "Empty storage" ~: getStorageSize [] ~?= 0
  , "Simple storage" ~: getStorageSize [("a",(0,8)),("b",(8,8))]
    ~?= 16
  ]
