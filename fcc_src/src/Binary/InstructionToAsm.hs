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
translateInstr BinNot        = ["    not"]
translateInstr BoolNot       = ["    lnot"]
translateInstr Negate        = ["    neg"]
translateInstr BinAnd        = ["    and"]
translateInstr BinOr         = ["    nor"]
translateInstr BoolAnd       = ["    land"]
translateInstr BoolOr        = ["    lor"]
translateInstr Xor           = ["    xor"]
translateInstr BitShiftLeft  = ["    shl"]
translateInstr BitShiftRight = ["    shr"]
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
translateInstr UpdateZFlag  = ["    updz"]
translateInstr (PushValue v)            = ["    push " ++ show v]
translateInstr (PushGlobAddr v)         = ["    push &" ++ show v]
translateInstr (PushRelAddr v)          = ["    push [" ++ show v ++ "]"]
translateInstr (PushLabel l)            = ["    push %" ++ l]
translateInstr (PushFromStackPtrRel a)  =
  ["    push @" ++ show a]
translateInstr (PopToStackPtrRel a)     = ["    pop @" ++ show a]
translateInstr PopEmpty               = ["    pop"]
translateInstr (WriteToStackPtrRel a v) =
  ["    wr @" ++ show a ++ " " ++ show v]
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
