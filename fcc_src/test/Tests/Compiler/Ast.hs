{-
-- EPITECH PROJECT, 2025
-- glados tests
-- File description:
-- Compiler.Ast
-}

module Tests.Compiler.Ast (astTest) where

import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm

import Test.HUnit (Test (TestList), (~:), (~?=))
import Compiler.Ast (compile)
import Error.MaybeError (MaybeError(Correct, Error))
import DataStruct.Ast.Variable as Var
import Error.ErrorList (functionArgumentMissmatch)

astTest :: Test
astTest = TestList
  [ "simple test" ~:
    compile (CAst (Main [Var.VariableDef "x" 42] [])
              [Function "foo" False [] [] []])
    ~?= Correct [ Asm.Label "func_main"
                , Asm.Label ".start"
                , PushValue 42
                , Ret
                , Asm.Label "func_foo"
                , Ret
                ]
  , "fail test" ~:
    compile (CAst (Main [] [Invoke "main" [Value 10] Nothing]) [])
    ~?= Error functionArgumentMissmatch "main: got 1 but expected 0"
  ]
