{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Creation of a readable binary file
-}

-- module Compiler.ReadableBinary ( transformReadableBinary ) where

module Compiler.ReadableBinary ( transformOneLineToBinary, transformToBinary
                      , Asm
                      , Instruction (..)
                      , Value (..)
                      , LabelName
                      , VariableName
                      ) where

-- test :: [Instruction]
-- test = [
--     Label ".data"
--   , Label ".str_HelloWorld"
--   , DataString "Hello, World!"
--   , Label ".str_HelloWorld_end"
--   , Label ".start"
--   , PushLabel ".str_HelloWorld_end"
--   , PushLabel ".str_HelloWorld"
--   , Sub -- Len of string #0 +1 ~1
--   , Label ".loop"
--   , Dupl -- #1 +1 ~2
--   , PushLabel ".end" -- #2 +1 ~3
--   , Zjmp -- -2 ~1
--   , Dupl -- #1 + 1 -- len ~2
--   , Negate -- +0 -- -len ~2
--   , PushLabel ".str_HelloWorld_end" -- #2 +1 ~3
--   , Add -- -1 -- .str_HelloWorld_end - len #1 ~2
--   , Aff -- Show "Hello, World!"[actual_len - len] -1 ~1
--   , PushValue 1 -- #1 +1 ~2
--   , Sub -- #0 -1 (new len = len - 1) ~1
--   , PushLabel ".loop"
--   , Jmp
--   , Label ".end"
--   ]

transformOneLineToBinary :: Instruction -> String
transformOneLineToBinary n = show n

transformToBinary :: [Instruction] -> String
transformToBinary [] = ""
transformToBinary (x:xs) = transformOneLineToBinary x ++ "\n" ++ transformToBinary xs

-- main :: IO ()
-- -- main = putStrLn $ unlines (map transformOneLineToBinary test)
-- main = putStrLn (transformToBinary test)
