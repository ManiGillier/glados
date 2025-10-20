{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec
-}

module VM.CallStack (
     updateCall
    ,restoreStack) 
    where 

import VM.Types

updateCall :: PC -> SP -> CallStack -> CallStack
updateCall pc sp cs = (pc + 1, sp) : cs

restoreStack :: CallStack -> ((PC, SP), CallStack)
restoreStack [] = ((0, 0), [])
restoreStack ((pc, sp):xs) = ((pc, sp), xs)
