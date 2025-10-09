{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Creation of a readable binary file
-}

module Binary.ReadableBinary (stackToAsm) where

import DataStruct.Asm
import Data.List (intercalate)
import Data.Int (Int64)

dataSection :: [Instruction] -> ([String], [String])
dataSection [] = ([], [])
dataSection (Label start : DataString s : Label end : rest) =
  let (labs, lines) = dataSection rest
  in (start : end : labs, (start ++ ":") : ("    db " ++ show s) : (end ++ ":") : lines)
dataSection (Label l : DataString s : rest) =
  let (labs, lines) = dataSection rest
  in (l : labs, (l ++ ":") : ("    db " ++ show s) : lines)
dataSection (Label start : DataInt n : Label end : rest) =
  let (labs, lines) = dataSection rest
  in (start : end : labs, (start ++ ":") : ("    dq " ++ show n) : (end ++ ":") : lines)
dataSection (Label l : DataInt n : rest) =
  let (labs, lines) = dataSection rest
  in (l : labs, (l ++ ":") : ("    dq " ++ show n) : lines)
dataSection (_ : rest) = dataSection rest

translateInstr :: Instruction -> [String]
translateInstr instr = case instr of
    Label l       -> [l ++ ":"]
    DataInt _     -> []
    DataString _  -> []
    BinNot        -> ["   binnot"]
    BoolNot       -> ["   boolnot"]
    Negate        -> ["   negate"]
    BinAnd        -> ["   binand"]
    BinOr         -> ["   binor"]
    BoolAnd       -> ["   booland"]
    BoolOr        -> ["   boolor"]
    Xor           -> ["   xor"]
    BitShiftLeft  -> ["   bitshiftleft"]
    BitShiftRight -> ["   bitshiftright"]
    Add           -> ["   add"]
    Sub           -> ["   sub"]
    Mult          -> ["   mult"]
    Div           -> ["   div"]
    Mod           -> ["   mod"]
    Gt            -> ["   gt"]
    Ge            -> ["   ge"]
    Lt            -> ["   lt"]
    Le            -> ["   le"]
    Eq            -> ["   eq"]
    Diff          -> ["   diff"]
    Is            -> ["   is"]
    UpdateZFlag   -> ["   updatezflag"]
    PushValue v   -> ["   pushvalue " ++ show v]
    PushGlobAddr v -> ["   pushglobaddr " ++ show v]
    PushRelAddr v  -> ["   pushreladdr " ++ show v]
    PushLabel l   -> ["   pushlabel " ++ l]
    PushFromStackPtrRel a -> ["   pushfromstackptrrel " ++ show a]
    PopToStackPtrRel a -> ["   poptostackptrrel " ++ show a]
    PopEmpty      -> ["   popempty"]
    WriteToStackPtrRel a v -> ["   writetostackptrrel " ++ show a ++ " " ++ show v]
    Dupl          -> ["   dupl"]
    Call          -> ["   call"]
    Ret           -> ["   ret"]
    Jmp           -> ["   jmp"]
    Zjmp          -> ["   zjmp"]
    Aff           -> ["   aff"]

reservedLabels :: [String]
reservedLabels = [".data", ".start"]

isPushLabel :: Instruction -> Bool
isPushLabel (PushLabel _) = True
isPushLabel _ = False

translate :: [String] -> [Instruction] -> [String]
translate _ [] = []
translate dataLabels (Label l : xs)
  | l `elem` dataLabels = translate dataLabels xs
  | l `elem` reservedLabels = translate dataLabels xs
  | otherwise = (l ++ ":") : translate dataLabels xs
translate dataLabels (DataString _ : xs) = translate dataLabels xs
translate dataLabels (instr : xs) =
  if isPushLabel instr
    then translate dataLabels xs
    else translateInstr instr ++ translate dataLabels xs

stackToAsm :: [Instruction] -> String
stackToAsm instrs =
  intercalate "\n"
    ( ["SECTION .data"]
      ++ dataLines
      ++ ["", "SECTION .text", "global _start", "_start:"]
      ++ codeLines
    )
  where
    (dataLabels, dataLines) = dataSection instrs
    codeLines = translate dataLabels instrs

-- test :: [Instruction]
-- test =
--     [ Label ".data"
--     , Label ".str_HelloWorld"
--     , DataString "Hello, World!"
--     , Label ".str_HelloWorld_end"
--     , Label ".start"
--     , PushLabel ".str_HelloWorld_end"
--     , PushLabel ".str_HelloWorld"
--     , Sub
--     , Label ".loop"
--     , Dupl
--     , PushLabel ".end"
--     , Zjmp
--     , Dupl
--     , Negate
--     , PushLabel ".str_HelloWorld_end"
--     , Add
--     , Aff
--     , PushValue 1
--     , Sub
--     , PushLabel ".loop"
--     , Jmp
--     , Label ".end"
--     ]

-- main :: IO ()
-- main = putStrLn (stackToAsm test)