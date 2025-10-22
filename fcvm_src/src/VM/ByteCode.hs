{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.ByteCode (checkMagicNumber, isInstruction, nextIns, skipVal) where 

import VM.Types

checkMagicNumber :: ByteCode -> Bool
checkMagicNumber (0x45:0xc:0x45:0xc:_) = True
checkMagicNumber _ = False

isInstruction :: ByteCode -> Int -> Bool
isInstruction bc pc
    | bc !! (pc - 1) == 0 = True
    | otherwise = False

nextIns :: PC -> PC
nextIns pc = pc + 1

skipVal :: PC -> PC
skipVal pc = pc + 9
