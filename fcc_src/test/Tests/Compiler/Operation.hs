{-
-- EPITECH PROJECT, 2025
-- glados test
-- File description:
-- compiler operation
-}

module Tests.Compiler.Operation (operationTest) where

import Test.HUnit ( (~:)
                  , Test(TestList)
                  , (~?=) ) 

import Compiler.Operation
import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm
import Error.MaybeError (MaybeError(..))
import Compiler.Type (baseContext, Context (Context))
import Error.ErrorList (ukVarErr)

v :: Ast.Computable
v = Ast.Value 42

v' :: Instruction
v' = Asm.PushValue 42

operationTest :: Test
operationTest = TestList $
  [ "computable" ~:
    [ "Variable not existing" ~: compileComputable baseContext (Ast.Variable "x")
      ~?= Error ukVarErr "x"
    , "Simple variable" ~: compileComputable (Context [("x", (0, 8))] 0 [] [])
      (Ast.Variable "x") ~?= Correct ((Context [("x", (0, 8))] 0 [] [])
                                     , [PushFromStackPtrRel 0])
    , "Simple int value" ~: compileComputable baseContext (Ast.Value 10)
      ~?= Correct (baseContext, [PushValue 10])
    , "False value" ~: compileComputable baseContext (Ast.Value 0)
      ~?= Correct (baseContext, [PushValue 0])
    , "True value" ~: compileComputable baseContext (Ast.Value 1)
      ~?= Correct (baseContext, [PushValue 1])
    , "Operation" ~: compileComputable baseContext
      (Ast.Operation $ Ast.UnaryOperation Ast.Negate (Ast.Value 1))
      ~?= Correct (baseContext, [PushValue 1, Asm.Negate])
    ]
  , "unary operation" ~:
    [ "BinNot" ~: compileOperation baseContext
      (Ast.UnaryOperation Ast.BinaryNot v)
      ~?= Correct (baseContext, v':[Asm.BinNot])
    , "BoolNot" ~: compileOperation baseContext
      (Ast.UnaryOperation Ast.BooleanNot v)
      ~?= Correct (baseContext, v':[Asm.BoolNot])
    , "Negate" ~: compileOperation baseContext
      (Ast.UnaryOperation Ast.Negate v)
      ~?= Correct (baseContext, v':[Asm.Negate])
    ]
  , "binary operation" ~:
    [ "BinAnd" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.BinaryAnd v v)
      ~?= Correct (baseContext, v':v':[Asm.BinAnd])
    , "BinOr" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.BinaryOr v v)
      ~?= Correct (baseContext, v':v':[Asm.BinOr])
    , "BoolAnd" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.BooleanAnd v v)
      ~?= Correct (baseContext, v':v':[Asm.BoolAnd])
    , "BoolOr" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.BooleanOr v v)
      ~?= Correct (baseContext, v':v':[Asm.BoolOr])
    , "Xor" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Xor v v)
      ~?= Correct (baseContext, v':v':[Asm.Xor])
    , "BitShiftLeft" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.BitShiftLeft v v)
      ~?= Correct (baseContext, v':v':[Asm.BitShiftLeft])
    , "BitShiftRight" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.BitShiftRight v v)
      ~?= Correct (baseContext, v':v':[Asm.BitShiftRight])
    , "Add" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Add v v)
      ~?= Correct (baseContext, v':v':[Asm.Add])
    , "Sub" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Sub v v)
      ~?= Correct (baseContext, v':v':[Asm.Sub])
    , "Mult" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Multiplication v v)
      ~?= Correct (baseContext, v':v':[Asm.Mult])
    , "Div" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Division v v)
      ~?= Correct (baseContext, v':v':[Asm.Div])
    , "Mod" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Modulo v v)
      ~?= Correct (baseContext, v':v':[Asm.Mod])
    , "Gt" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Superior v v)
      ~?= Correct (baseContext, v':v':[Asm.Gt])
    , "Ge" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.SuperiorOrEq v v)
      ~?= Correct (baseContext, v':v':[Asm.Ge])
    , "Lt" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Inferior v v)
      ~?= Correct (baseContext, v':v':[Asm.Lt])
    , "Le" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.InferiorOrEq v v)
      ~?= Correct (baseContext, v':v':[Asm.Le])
    , "Eq" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Equals v v)
      ~?= Correct (baseContext, v':v':[Asm.Eq])
    , "Diff" ~: compileOperation baseContext
      (Ast.BinaryOperation Ast.Different v v)
      ~?= Correct (baseContext, v':v':[Asm.Diff])
    ]
  ]
