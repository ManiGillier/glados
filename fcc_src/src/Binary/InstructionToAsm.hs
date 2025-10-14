{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Creation of a readable binary file
-}

module Binary.InstructionToAsm (instructionToListOfAsm, instructionToAsm) where

import DataStruct.Asm

translateInstr :: Instruction -> [String]
translateInstr (Label l)     = [l ++ ":"]
translateInstr (DataInt i)   = ["    db " ++ show i]
translateInstr (DataString s)= ["    db " ++ show s]
translateInstr BinNot        = ["    binnot"]
translateInstr BoolNot       = ["    boolnot"]
translateInstr Negate        = ["    negate"]
translateInstr BinAnd        = ["    binand"]
translateInstr BinOr         = ["    binor"]
translateInstr BoolAnd       = ["    booland"]
translateInstr BoolOr        = ["    boolor"]
translateInstr Xor           = ["    xor"]
translateInstr BitShiftLeft  = ["    bitshiftleft"]
translateInstr BitShiftRight = ["    bitshiftright"]
translateInstr Add          = ["    add"]
translateInstr Sub          = ["    sub"]
translateInstr Mult         = ["    mult"]
translateInstr Div          = ["    div"]
translateInstr Mod          = ["    mod"]
translateInstr Gt           = ["    gt"]
translateInstr Ge           = ["    ge"]
translateInstr Lt           = ["    lt"]
translateInstr Le           = ["    le"]
translateInstr Eq           = ["    eq"]
translateInstr Diff         = ["    diff"]
translateInstr Is           = ["    is"]
translateInstr UpdateZFlag  = ["    updatezflag"]
translateInstr (PushValue v)            = ["    pushvalue " ++ show v]
translateInstr (PushGlobAddr v)         = ["    pushglobaddr " ++ show v]
translateInstr (PushRelAddr v)          = ["    pushreladdr " ++ show v]
translateInstr (PushLabel l)            = ["    pushlabel " ++ l]
translateInstr (PushFromStackPtrRel a)  =
  ["    pushfromstackptrrel " ++ show a]
translateInstr (PopToStackPtrRel a)     = ["    poptostackptrrel " ++ show a]
translateInstr PopEmpty               = ["    popempty"]
translateInstr (WriteToStackPtrRel a v) =
  ["    writetostackptrrel " ++ show a ++ " " ++ show v]
translateInstr Dupl                   = ["    dupl"]
translateInstr Call                   = ["    call"]
translateInstr Ret                    = ["    ret"]
translateInstr Jmp                    = ["    jmp"]
translateInstr Zjmp                   = ["    zjmp"]
translateInstr Aff                    = ["    aff"]

listOfStringToString :: [String] -> String
listOfStringToString [] = ""
listOfStringToString (x:xs) = x ++ "\n" ++ listOfStringToString xs

instructionToListOfAsm :: [Instruction] -> [String]
instructionToListOfAsm xs = concatMap translateInstr xs

instructionToAsm :: [Instruction] -> String
instructionToAsm xs = listOfStringToString (concatMap translateInstr xs)
