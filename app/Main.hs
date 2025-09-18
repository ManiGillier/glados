{--
-- EPITECH PROJECT, 2025
-- GLaDOS
-- File description:
-- Ast
--}

module Main (main) where

import qualified Lisp.Exec.Exec as Exec
import Lisp.Exec.SymboleTable
import Lisp.Ast.Ast

testCases :: [Ast]
testCases = 
    [ Value 42
    , Define "x" (Value 42)
    , Define "y" (Call "+" [Value 10, Call "+" [Value 2, Value 3]])
    , Define "y" (Value 32)
    , ASymbol "x"
    , ASymbol "y"
    , Call "+" [ASymbol "y", Value 2]
    , Call "+" [Value 10, Value 2]
    , Call "*" [Value 5, Call "+" [Value 2, Value 3]]
    , Call "-" [Value 100, Call "div" [Value 20, Value 4]]
    , Call "eq?" [Value 5, Value 5]
    , Call "<" [Value 7, Value 3]
    , Define "addone" (Lambda ["x"] (Call "+" [ASymbol "x", Value 1]))
    , Call "addone" [Value 41]
    , Apply (Lambda ["x","y","z"] (Call "*" [ASymbol "x", Call "*" [ASymbol "y", ASymbol "z"]])) 
     [Value 2, Value 2, Value 2]
     -- VARIADIC OPERATIONS
     , Call "+" [Value 2, Value 2, Value 2]
     , Call "-" [Value 2, Value 2, Value 2]
     , Call "*" [Value 2, Value 2, Value 2]
     -- ERROR CASE 
     , (Lambda ["x" , "y", "z"] (Call "*" [ASymbol "x", Call "*" [ASymbol "y", ASymbol "z"]]))
     , Call "y" []
     , ASymbol "p"
     , Call "*" [Value 2]
     , ASymbol "addone"
    ]

testOne :: Ast -> SymTable -> IO SymTable
testOne ast env = do
    putStrLn $ "cur ast = " ++ show ast
    let (result, newEnv) = Exec.execLisp ast env
    putStrLn $ "res = " ++ result
    putStrLn $ "env = " ++ show newEnv
    putStrLn ""
    return newEnv

testExecHelper :: [Ast] -> SymTable -> IO ()
testExecHelper [] _ = return ()
testExecHelper (ast:rest) env = do
    newEnv <- testOne ast env
    testExecHelper rest newEnv

testExec :: IO ()
testExec = do
    let env = []
    testExecHelper testCases env

main :: IO ()
main = testExec
