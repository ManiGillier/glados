{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- Linker.LinkAst
-}

module Tests.Linker.LinkAst (linkTest) where

import Linker.LinkAst (link)
import Test.HUnit (Test (TestList), (~:), (~?=))
import Error.MaybeError (MaybeError(Error, Correct))
import Error.ErrorList (noMainErr, alreadyDefFuncErr)
import DataStruct.Ast.Ast (Ast(Ast)
                          , MainFunctionDef (Main)
                          , CombinedAst (CAst), FunctionDef (Function))
import DataStruct.Ast.Variable (ReturnType(Void))

linkTest :: Test
linkTest = TestList
  [ "Nothing to link" ~:
    link [] ~?= Error noMainErr ""
  , "Simple main" ~:
    link [Ast (Just $ Main [] []) []]
    ~?= Correct (CAst (Main [] []) [])
  , "Double main" ~:
    link [ Ast (Just $ Main [] []) []
         , Ast (Just $ Main [] []) []
         ]
    ~?= Error alreadyDefFuncErr "main"
  , "Different funcs" ~:
    link [ Ast (Just $ Main [] []) [Function "foo" Void [] [] []]
         , Ast Nothing [Function "bar" Void [] [] []]
         ]
    ~?= Correct (CAst (Main [] [])
                [ Function "foo" Void [] [] []
                , Function "bar" Void [] [] []
                ])
  , "Duplicate funcs" ~:
    link [ Ast (Just $ Main [] []) [Function "foo" Void [] [] []]
         , Ast Nothing [Function "foo" Void [] [] []]
         ]
    ~?= Correct (CAst (Main [] [])
                [ Function "foo" Void [] [] []
                , Function "foo" Void [] [] []
                ])
  , "Duplicate funcs no main" ~:
    link [ Ast Nothing [Function "foo" Void [] [] []]
         , Ast Nothing [Function "foo" Void [] [] []]
         ]
    ~?= Error noMainErr ""
  ]
