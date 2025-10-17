{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Asm
-}

module DataStruct.Asm (Asm
                      , Instruction (..)
                      , Value (..)
                      , LabelName
                      , VariableName
                      , Addr
                      ) where
import Data.Word (Word8)

type LabelName = String
type VariableName = String

type Addr = Int

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
  | PushFromStackPtrRel !Addr -- Push the value stored here
  -- Pop (Pop 4 bytes from the stack)
  | PopToStackPtrRel !Addr -- Pop and set to the address :D
  | PopEmpty
  -- Stack writing
  | WriteToStackPtrRel !Addr !Int -- Write Int to stack ptr + Addr
  -- Both
  | Dupl -- Duplicates last stack entry
  -- Function (modified stack)
  | Call -- Remember stack pointer :D
  | Ret -- Retrieve caller stack pointer :D
  -- Jumps (POPS addr from stack)
  | Jmp
  | Zjmp -- Pops test from stack (if == 0, jump else continue)
  -- Debug functions (to remove later)
  | Aff -- Shows single char from addr popped from stack
  deriving (Show)

-- Addr is the address added to the address of the stack pointer !

type Asm = [Instruction]

aymerick :: Instruction -> String
aymerick = show

maxime :: Instruction -> [Word8]
maxime _ = []

maxime_2 :: [Instruction] -> [Word8]
maxime_2 _ = []
{-
test :: [Instruction]
test = [
    Label ".data"
  , Label ".str_HelloWorld"
  , DataString "Hello, World!"
  , Label ".str_HelloWorld_end"
  , Label ".start"
  , PushLabel ".str_HelloWorld_end"
  , PushLabel ".str_HelloWorld"
  , Sub -- Len of string #0 +1 ~1
  , Label ".loop"
  , Dupl -- #1 +1 ~2
  , PushLabel ".end" -- #2 +1 ~3
  , Zjmp -- -2 ~1
  , Dupl -- #1 + 1 -- len ~2
  , Negate -- +0 -- -len ~2
  , PushLabel ".str_HelloWorld_end" -- #2 +1 ~3
  , Add -- -1 -- .str_HelloWorld_end - len #1 ~2
  , Aff -- Show "Hello, World!"[actual_len - len] -1 ~1
  , PushValue 1 -- #1 +1 ~2
  , Sub -- #0 -1 (new len = len - 1) ~1
  , PushLabel ".loop"
  , Jmp
  , Label ".end"
  ]
-}
