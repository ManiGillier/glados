{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- compiler security
-}

module Tests.Compiler.Security ( securityTest ) where
import Test.HUnit
import Compiler.Security (checkFunctionCall, getFunctionDefFromName, returnValueCheckSingle)
import Compiler.Type (Context(Context), f2c, FunctionContext (FunctionContext), f2cf)
import Error.MaybeError (MaybeError(Correct, Error))
import Error.ErrorList (undefinedFunctionErr, assignementFromVoidFunc)

normalContext :: Context
normalContext = Context [] 0 (f2c ["main", "putnbr", "test"])
  $ f2c ["putnbr", "test", "putnbr"]

errorContext :: Context
errorContext = Context [] 0 (f2c ["main", "test"])
  $ f2c ["test", "putnbr", "test"]

securityTest :: Test
securityTest = TestList $
  [ "No problems" ~: checkFunctionCall (normalContext, [])
    ~?= Correct (normalContext, [])
  , "Undefined function" ~: checkFunctionCall (errorContext, [])
    ~?= Error undefinedFunctionErr "putnbr"
  , "getFunctionFromName" ~:
    [ "No function" ~: getFunctionDefFromName [] "test"
      ~?= Nothing
    , "Function found" ~: getFunctionDefFromName (f2c ["a", "test", "b"])
      "test" ~?= Just (FunctionContext "test" True 0)
    ]
  , "returnValueCheckSingle" ~:
    [ "function non void not assigned" ~:
      returnValueCheckSingle (f2c ["test"]) (FunctionContext "test" False 0)
      ~?= Nothing
    , "function non void assigned" ~:
      returnValueCheckSingle (f2c ["test"]) (FunctionContext "test" True 0)
      ~?= Nothing
    , "function void not assigned" ~:
      returnValueCheckSingle (f2cf ["test"]) (FunctionContext "test" False 0)
      ~?= Nothing
    , "function void assigned" ~:
      returnValueCheckSingle (f2cf ["test"]) (FunctionContext "test" True 0)
      ~?= Just "test"
    ]
  , "Assignement from void function" ~: checkFunctionCall
    ((Context [] 0 (f2cf ["main", "test"]) (f2c ["test"])), [])
    ~?= Error assignementFromVoidFunc "test"
  ]
