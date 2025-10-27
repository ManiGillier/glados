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
    combineAst [ Ast (Just $ Main [] []) [Function "foo" False [] [] []]
         , Ast Nothing [Function "bar" False [] [] []]
         ]
    ~?= Correct (CAst (Main [] [])
                [ Function "foo" False [] [] []
                , Function "bar" False [] [] []
                ])
  , "Duplicate funcs" ~:
    combineAst [ Ast (Just $ Main [] []) [Function "foo" False [] [] []]
         , Ast Nothing [Function "foo" False [] [] []]
         ]
    ~?= Correct (CAst (Main [] [])
                [ Function "foo" False [] [] []
                , Function "foo" False [] [] []
                ])
  , "Duplicate funcs no main" ~:
    combineAst [ Ast Nothing [Function "foo" False [] [] []]
         , Ast Nothing [Function "foo" False [] [] []]
         ]
    ~?= Error noMainErr ""
  ]
