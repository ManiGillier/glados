{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Creation of a readable binary file
-}

module Binary.ReadableBinary (readableAsm, readableAsmToString) where

import DataStruct.Asm
import Data.Int (Int64)

translateInstr :: Instruction -> [String]
translateInstr (Label l)     = [l ++ ":"]
translateInstr (DataInt i)   = ["\tdb " ++ show i]
translateInstr (DataString s)= ["\tdb " ++ show s]
translateInstr BinNot        = ["\tbinnot"]
translateInstr BoolNot       = ["\tboolnot"]
translateInstr Negate        = ["\tnegate"]
translateInstr BinAnd        = ["\tbinand"]
translateInstr BinOr         = ["\tbinor"]
translateInstr BoolAnd       = ["\tbooland"]
translateInstr BoolOr        = ["\tboolor"]
translateInstr Xor           = ["\txor"]
translateInstr BitShiftLeft  = ["\tbitshiftleft"]
translateInstr BitShiftRight = ["\tbitshiftright"]
translateInstr Add          = ["\tadd"]
translateInstr Sub          = ["\tsub"]
translateInstr Mult         = ["\tmult"]
translateInstr Div          = ["\tdiv"]
translateInstr Mod          = ["\tmod"]
translateInstr Gt           = ["\tgt"]
translateInstr Ge           = ["\tge"]
translateInstr Lt           = ["\tlt"]
translateInstr Le           = ["\tle"]
translateInstr Eq           = ["\teq"]
translateInstr Diff         = ["\tdiff"]
translateInstr Is           = ["\tis"]
translateInstr UpdateZFlag  = ["\tupdatezflag"]
translateInstr (PushValue v)            = ["\tpushvalue " ++ show v]
translateInstr (PushGlobAddr v)         = ["\tpushglobaddr " ++ show v]
translateInstr (PushRelAddr v)          = ["\tpushreladdr " ++ show v]
translateInstr (PushLabel l)            = ["\tpushlabel " ++ l]
translateInstr (PushFromStackPtrRel a)  = ["\tpushfromstackptrrel " ++ show a]
translateInstr (PopToStackPtrRel a)     = ["\tpoptostackptrrel " ++ show a]
translateInstr PopEmpty               = ["\tpopempty"]
translateInstr (WriteToStackPtrRel a v) =
  ["\twritetostackptrrel " ++ show a ++ " " ++ show v]
translateInstr Dupl                   = ["\tdupl"]
translateInstr Call                   = ["\tcall"]
translateInstr Ret                    = ["\tret"]
translateInstr Jmp                    = ["\tjmp"]
translateInstr Zjmp                   = ["\tzjmp"]
translateInstr Aff                    = ["\taff"]

listOfStringToString :: [String] -> String
listOfStringToString [] = ""
listOfStringToString (x:xs) = x ++ "\n" ++ listOfStringToString xs

readableAsm :: [Instruction] -> [String]
readableAsm xs = concatMap translateInstr xs

readableAsmToString :: [Instruction] -> String
readableAsmToString xs = listOfStringToString (concatMap translateInstr xs)
