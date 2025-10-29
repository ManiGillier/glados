{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- compiler security
-}

module Tests.Compiler.Security ( securityTest ) where
import Test.HUnit
import Compiler.Security (checkFunctionCall)
import Compiler.Type (Context(Context))
import Error.MaybeError (MaybeError(Correct, Error))
import Error.ErrorList (undefinedFunctionErr)

normalContext :: Context
normalContext = Context [] 0 ["main", "putnbr", "test"]
  ["putnbr", "test", "putnbr"]

errorContext :: Context
errorContext = Context [] 0 ["main", "test"]
  ["test", "putnbr", "test"]

securityTest :: Test
securityTest = TestList $
  [ "No problems" ~: checkFunctionCall (normalContext, [])
    ~?= Correct (normalContext, [])
  , "Simple problem" ~: checkFunctionCall (errorContext, [])
    ~?= Error undefinedFunctionErr "putnbr"
  ]
