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
import DataStruct.Ast.Type as T
import DataStruct.Ast.Variable as Var

import Compiler.FunctionDef (compileFuncDef, compileMainDef)
import Compiler.Type (Context (..), baseContext)
import Error.MaybeError (MaybeError(Error, Correct))
import Error.ErrorList (alreadyDefFuncErr, alreadyDefVarErr, supportErr)
import Data.Int (Int64)

f :: Context
f = Context [] 0 ["f"]

v :: Int64 -> Ast.Computable
v i = Ast.Value $ Var.Int i

v' :: Int64 -> Instruction
v' = Asm.PushValue

functionDefTest :: Test
functionDefTest = TestList
  [ "function def" ~:
    [ "function already defined" ~: compileFuncDef f
      (Function "f" Var.Void [] [] []) ~?= Error alreadyDefFuncErr "f"
    , "new function" ~: compileFuncDef baseContext
      (Function "f" Var.Void [Var.FuncParam "x" T.Int]
       [Var.VariableDef "y" T.Int $ Var.Int 84]
       [Assign "x" $ v 42])
      ~?= Correct (f, [ Asm.Label "func_f", PushValue 84
                      , v' 42, PopToStackPtrRel (-8) -- Assign x
                      , Ret])
    , "no params" ~: compileFuncDef baseContext
      (Function "f" Var.Void [] [] [])
      ~?= Correct (f, [Asm.Label "func_f", Ret])
    , "multiple params" ~: compileFuncDef baseContext
      (Function "f" Var.Void [ Var.FuncParam "x" T.Int
                             , Var.FuncParam "y" T.Int] []
        [Assign "x" $ v 42, Assign "y" $ v 41])
      ~?= Correct (f, [ Asm.Label "func_f"
                      , v' 42, PopToStackPtrRel (-8) -- Assign x
                      , v' 41, PopToStackPtrRel (-16) -- Assign y
                      , Ret])
    , "duplicate param" ~: compileFuncDef baseContext
      (Function "f" Var.Void [ Var.FuncParam "x" T.Int
                             , Var.FuncParam "x" T.Int] []
        [Assign "x" $ v 42, Assign "y" $ v 41])
      ~?= Error alreadyDefVarErr "x"
    , "duplicate var" ~: compileFuncDef baseContext
      (Function "f" Var.Void [] [ Var.VariableDef "x" T.Int $ Var.Int 64
                                , Var.VariableDef "x" T.Int $ Var.Int 32 ]
        [Assign "x" $ v 42, Assign "x" $ v 41])
      ~?= Error alreadyDefVarErr "x"
    , "duplicate param 2" ~: compileFuncDef baseContext
      (Function "f" Var.Void [ Var.FuncParam "x" T.Int
                             , Var.FuncParam "y" T.Int
                             , Var.FuncParam "z" T.Int
                             , Var.FuncParam "z" T.Int
                             , Var.FuncParam "x" T.Int
                             ] [] [])
      ~?= Error alreadyDefVarErr "x"
    , "duplicate param 3" ~: compileFuncDef baseContext
      (Function "f" Var.Void [ Var.FuncParam "x" T.Int
                             , Var.FuncParam "y" T.Int
                             , Var.FuncParam "z" T.Int
                             , Var.FuncParam "z" T.Int
                             , Var.FuncParam "z" T.Int
                             ] [] [])
      ~?= Error alreadyDefVarErr "z"
    ]
  , "main function def" ~:
    [ "simple main" ~: compileMainDef baseContext
      (Main [Var.VariableDef "x" T.Int $ Var.Int 10] [Assign "x" $ v 42])
      ~?= Correct (Context [("x", (0,8))] 0 ["main"],
                   [ Label "func_main", Label ".start"
                   , v' 10
                   , v' 42, PopToStackPtrRel 0
                   , Ret
                   ])
    ]
  , "unsupported type" ~:
    [ "simple main" ~: compileMainDef baseContext
      (Main [Var.VariableDef "x" T.Bool $ Var.Bool False] [])
      ~?= Error supportErr "Bool"
    ]
  ]
