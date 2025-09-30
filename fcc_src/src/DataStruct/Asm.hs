{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Asm
-}

module DataStruct.Asm (Asm) where
import Data.Binary (Word8)

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
  | Call
  | Ret
  | Jmp
  | ZJmp
  deriving (Show)

type Asm = [Instruction]

aymerick :: Instruction -> String
aymerick = show

maxime :: Instruction -> [Word8]
maxime _ = []

maxime_2 :: [Instruction] -> [Word8]
maxime_2 _ = []
