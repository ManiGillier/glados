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
  -- Label definition (bin output = [])
  Label !LabelName
  -- Unary
  | DataInt !Int
  | DataString !String
  | BinNot
  | BoolNot
  | Negate
  -- Binary
  | BinAnd
  | BinOr
  | BoolAnd
  | BoolOr
  | Xor
  | BitShiftLeft
  | BitShiftRight
  | Add
  | Sub
  | Mult
  | Div
  | Mod
  | Gt -- Greater
  | Ge -- Greater or equal
  | Lt -- Less
  | Le -- Less or equal
  | Eq
  | Diff
  | Is
  -- Push (Push 4 byte to the stack)
  | PushValue !Int
  | PushGlobAddr !Int
  | PushRelAddr !Int
  | PushLabel !LabelName -- Same bytecode as PushRelAddr
  | PushStackRel !Int
  -- Pop (Pop 4 bytes from the stack)
  | PopStackRel !Int
  | PopEmpty
  -- Both
  | Dupl -- Duplicates last stack entry
  -- Function (modified stack)
  | Call
  | Ret
  -- Jumps (POPS addr from stack)
  | Jmp
  | Zjmp -- If zero flag == true jump else continue
  -- Debug functions (to remove later)
  | Aff
  deriving (Show)

type Asm = [Instruction]

aymerick :: Instruction -> String
aymerick = show

maxime :: Instruction -> [Word8]
maxime _ = []

maxime_2 :: [Instruction] -> [Word8]
maxime_2 _ = []
