{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler of operations
-}

module Compiler.Operation ( compileOperation
                          , compileComputable) where

import DataStruct.Ast.Ast as Ast
import DataStruct.Asm as Asm
import DataStruct.Ast.Variable (VariableValue(Int, Bool))

getUnOp :: UnaryOperator -> Instruction
getUnOp Ast.BinaryNot = Asm.BinNot
getUnOp Ast.BooleanNot = Asm.BoolNot
getUnOp Ast.Negate = Asm.Negate

getBinOp :: BinaryOperator -> Instruction
getBinOp Ast.BinaryAnd = Asm.BinAnd
getBinOp Ast.BinaryOr = Asm.BinOr
getBinOp Ast.BooleanAnd = Asm.BoolAnd
getBinOp Ast.BooleanOr = Asm.BoolOr
getBinOp Ast.Xor = Asm.Xor
getBinOp Ast.BitShiftLeft = Asm.BitShiftLeft
getBinOp Ast.BitShiftRight = Asm.BitShiftRight
getBinOp Ast.Add = Asm.Add
getBinOp Ast.Sub = Asm.Sub
getBinOp Ast.Multiplication = Asm.Mult
getBinOp Ast.Division = Asm.Div
getBinOp Ast.Modulo = Asm.Mod
getBinOp Ast.Superior = Asm.Gt
getBinOp Ast.SuperiorOrEq = Asm.Ge
getBinOp Ast.Inferior = Asm.Lt
getBinOp Ast.InferiorOrEq = Asm.Le
getBinOp Ast.Equals = Asm.Eq
getBinOp Ast.Is = Asm.Is
getBinOp Ast.Different = Asm.Diff

compileComputable :: Computable -> Maybe [Instruction]
-- Computable Value
compileComputable (Value (Int x)) = Just $ [PushValue x]
compileComputable (Value (Bool False)) = Just $ [PushValue 0]
compileComputable (Value (Bool True)) = Just $ [PushValue 1]
compileComputable (Value _) = Nothing
-- Computable Variable
compileComputable (Ast.Variable _) = error $ "TODO: Implement variable"
-- Computable Operation
compileComputable (Ast.Operation op) = compileOperation op
-- compileComputable _ = Nothing

compileOperation :: Operation -> Maybe [Instruction]
compileOperation (UnaryOperation op computable) =
  liftA2 (++) (compileComputable computable) (Just [getUnOp op])
compileOperation (BinaryOperation op c0 c1) =
  liftA2 (++) values (Just [getBinOp op])
  where values = liftA2 (++) (compileComputable c0) (compileComputable c1)
-- compileOperation _ = Nothing
