{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Asm
-}

module DataStruct.Asm (Asm) where

type LabelName = String
type VariableName = String

data Value =
  StackPos !Int
  | GlobalPos !Int
  | RelativePos !Int
  | LabelPos !LabelName
  | Variable !VariableName
  deriving (Show)

data Instruction =
  Label !LabelName
  | Add
  | Sub
  -- Add more here
  | Push !Value
  | Pop !Value
  | Call !LabelName
  | Ret
  | Jmp
  | ZJmp
  deriving (Show)

type Asm = [Instruction]
