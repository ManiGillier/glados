{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- Linker.LinkAst
-}

module Tests.Combinor.Ast (combineAstTest) where

import Combinor.Ast (combineAst)
import Test.HUnit (Test (TestList), (~:), (~?=))
import Error.MaybeError (MaybeError(Error, Correct))
import Error.ErrorList (noMainErr, alreadyDefFuncErr)
import DataStruct.Ast.Ast (Ast(Ast)
                          , MainFunctionDef (Main)
                          , CombinedAst (CAst), FunctionDef (Function))
import DataStruct.Ast.Variable (ReturnType(Void))

combineAstTest :: Test
combineAstTest = TestList
  [ "Nothing to combine" ~:
    combineAst [] ~?= Error noMainErr ""
  , "Simple main" ~:
    combineAst [Ast (Just $ Main [] []) []]
    ~?= Correct (CAst (Main [] []) [])
  , "Double main" ~:
    combineAst [ Ast (Just $ Main [] []) []
         , Ast (Just $ Main [] []) []
         ]
    ~?= Error alreadyDefFuncErr "main"
  , "Different funcs" ~:
    combineAst [ Ast (Just $ Main [] []) [Function "foo" Void [] [] []]
         , Ast Nothing [Function "bar" Void [] [] []]
         ]
    ~?= Correct (CAst (Main [] [])
                [ Function "foo" Void [] [] []
                , Function "bar" Void [] [] []
                ])
  , "Duplicate funcs" ~:
    combineAst [ Ast (Just $ Main [] []) [Function "foo" Void [] [] []]
         , Ast Nothing [Function "foo" Void [] [] []]
         ]
    ~?= Correct (CAst (Main [] [])
                [ Function "foo" Void [] [] []
                , Function "foo" Void [] [] []
                ])
  , "Duplicate funcs no main" ~:
    combineAst [ Ast Nothing [Function "foo" Void [] [] []]
         , Ast Nothing [Function "foo" Void [] [] []]
         ]
    ~?= Error noMainErr ""
  ]
