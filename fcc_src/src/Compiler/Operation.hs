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
import Compiler.Type ( combine, Compiler, getVariable )
import Error.MaybeError (MaybeError(..))

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
getBinOp Ast.Different = Asm.Diff

compileUnOp :: Compiler UnaryOperator
compileUnOp s op = Correct (s, [getUnOp op])

compileBinOp :: Compiler BinaryOperator
compileBinOp s op = Correct (s, [getBinOp op])

compileComputable :: Compiler Computable
-- Computable Value
compileComputable s (Value x) = Correct $ (s, [PushValue x])
-- Computable Variable
compileComputable s (Ast.Variable name) =
  (\addr -> (s,[PushFromStackPtrRel addr])) <$> getVariable s name
-- Computable Operation
compileComputable s (Ast.Operation op) = compileOperation s op
-- compileComputable _ = Nothing

compileOperation :: Compiler Operation
compileOperation s (UnaryOperation op computable) = total
  where total = (combine compileComputable compileUnOp) s (computable,op)
compileOperation s (BinaryOperation op c0 c1) = total
  where c = (combine compileComputable compileComputable)
        total = (combine c compileBinOp) s ((c0,c1),op)
-- compileOperation _ = Nothing
