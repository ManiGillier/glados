{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- Compiler.FunctionDef
-}

module Tests.Compiler.FunctionDef (functionDefTest) where
import Test.HUnit (Test (TestList), (~:), (~?=))

import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm
import DataStruct.Ast.Variable as Var

import Compiler.FunctionDef (compileFuncDef, compileMainDef)
import Compiler.Type (Context (..), baseContext)
import Error.MaybeError (MaybeError(Error, Correct))
import Error.ErrorList (alreadyDefFuncErr, alreadyDefVarErr)
import Data.Int (Int64)

f :: Context
f = Context [] 0 ["f"]

v :: Int64 -> Ast.Computable
v i = Ast.Value i

v' :: Int64 -> Instruction
v' = Asm.PushValue

functionDefTest :: Test
functionDefTest = TestList
  [ "function def" ~:
    [ "function already defined" ~: compileFuncDef f
      (Function "f" False [] [] []) ~?= Error alreadyDefFuncErr "f"
    , "new function" ~: compileFuncDef baseContext
      (Function "f" False [Var.FuncParam "x"]
       [Var.VariableDef "y" 84]
       [Assign "x" $ v 42])
      ~?= Correct (f, [ Asm.Label "func_f", PushValue 84
                      , v' 42, PopToStackPtrRel (-16) -- Assign x
                      , Ret])
    , "no params" ~: compileFuncDef baseContext
      (Function "f" False [] [] [])
      ~?= Correct (f, [Asm.Label "func_f", Ret])
    , "multiple params" ~: compileFuncDef baseContext
      (Function "f" False [ Var.FuncParam "x"
                             , Var.FuncParam "y"] []
        [Assign "x" $ v 42, Assign "y" $ v 41])
      ~?= Correct (f, [ Asm.Label "func_f"
                      , v' 42, PopToStackPtrRel (-16) -- Assign x
                      , v' 41, PopToStackPtrRel (-24) -- Assign y
                      , Ret])
    , "duplicate param" ~: compileFuncDef baseContext
      (Function "f" False [ Var.FuncParam "x"
                             , Var.FuncParam "x"] []
        [Assign "x" $ v 42, Assign "y" $ v 41])
      ~?= Error alreadyDefVarErr "x"
    , "duplicate var" ~: compileFuncDef baseContext
      (Function "f" False [] [ Var.VariableDef "x" 64
                                , Var.VariableDef "x" 32 ]
        [Assign "x" $ v 42, Assign "x" $ v 41])
      ~?= Error alreadyDefVarErr "x"
    , "duplicate param 2" ~: compileFuncDef baseContext
      (Function "f" False [ Var.FuncParam "x"
                             , Var.FuncParam "y"
                             , Var.FuncParam "z"
                             , Var.FuncParam "z"
                             , Var.FuncParam "x"
                             ] [] [])
      ~?= Error alreadyDefVarErr "x"
    , "duplicate param 3" ~: compileFuncDef baseContext
      (Function "f" False [ Var.FuncParam "x"
                             , Var.FuncParam "y"
                             , Var.FuncParam "z"
                             , Var.FuncParam "z"
                             , Var.FuncParam "z"
                             ] [] [])
      ~?= Error alreadyDefVarErr "z"
    ]
  , "main function def" ~:
    [ "simple main" ~: compileMainDef baseContext
      (Main [Var.VariableDef "x" 10] [Assign "x" $ v 42])
      ~?= Correct (Context [("x", (0,8))] 0 ["main"],
                   [ Label "func_main", Label ".start"
                   , v' 10
                   , v' 42, PopToStackPtrRel 0
                   , Ret
                   ])
    ]
  ]
