module Main (main) where

import qualified Lisp.Exec.Exec as Exec
import Lisp.Ast.Ast

testCases :: [Ast]
testCases = 
    [ Value 42
    , ASymbol "x"
    , Define "x" (Value 42)
    , ASymbol "x"
    , Call "+" [Value 10, Value 2]
    , Call "*" [Value 5, Call "+" [Value 2, Value 3]]
    , Call "-" [Value 100, Call "div" [Value 20, Value 4]]
    , Call "eq?" [Value 5, Value 5]
    , Call "<" [Value 7, Value 3]
    , Lambda ["x"] (Call "+" [ASymbol "x", Value 1])
    ]

testOne :: Ast -> Env -> IO Env
testOne ast env = do
    putStrLn $ "cur ast = " ++ show ast
    let (result, newEnv) = Exec.execLisp ast env
    putStrLn $ "res = " ++ result
    putStrLn $ "env = " ++ show newEnv
    putStrLn ""
    return newEnv

testExecHelper :: [Ast] -> Env -> IO ()
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
