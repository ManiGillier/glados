{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec 
-}

module Lisp.Exec.Exec (execLisp) where

import qualified Lisp.Exec.Builtin as Builtin
import Lisp.Ast.Ast

-- Main function of lisp execution
execLisp :: Ast -> Env -> (Maybe Int, Env)
execLisp ast env = evalAst env ast 

evalAst :: Env -> Ast -> (Maybe Int, Env)
evalAst env ast =
    case ast of
        Value x -> (Just x,env)
        ASymbol s -> lookupTable env s
        Define sym a -> defineSym env sym a
        Call f args -> evalCall env f args
        Lambda params body -> evalLambda env params body

-- Check if the Symbol already exist
lookupTable :: Env -> String -> (Maybe Int, Env)
-- TODO: add exeption
-- lookupTable [] e tar = ("Exception: variable " ++ tar ++ " is not bound", e)
lookupTable env@[] _ = (Nothing, env)
lookupTable env@((sym, val):rest) target
    | sym == target = evalAst env val
    | otherwise = lookupTable rest target

-- Define Symbol and keep it with env variable 
defineSym :: Env -> Symbol -> Ast -> (Maybe Int, Env)
defineSym [] s a = (Nothing, [(s, a)])
defineSym ((sym,val):rest) s a
    | sym == s  = (Nothing, (sym,a) : rest)
    | otherwise = let (res, newEnv) = defineSym rest s a
                  in (res, (sym,val) : newEnv)

-- Call builtin function
-- TODO : check if builtin is replace
evalCall :: Env -> String -> [Ast] -> (Maybe Int, Env)
evalCall env funcName args = case funcName of
    "+" -> (evalBinaryOp env Builtin.add args, env)
    "-" -> (evalBinaryOp env Builtin.sub args, env)
    "*" -> (evalBinaryOp env Builtin.mul args, env)
    "div" -> (evalBinaryOp env Builtin.safeDiv args, env)
    "mod" -> (evalBinaryOp env Builtin.safeMod args, env)
    "eq?" ->  (evalBinaryOp env Builtin.equal args, env)
    "<" ->  (evalBinaryOp env Builtin.infsign args, env)
    _ -> otherCall env funcName args

evalBinaryOp :: Env -> (Int -> Int -> Int) -> [Ast] -> Maybe Int
evalBinaryOp env op [arg1, arg2] = do
    let (val1, _) = evalAst env arg1
    let (val2, _) = evalAst env arg2
    case (val1, val2) of
        (Just v1, Just v2) -> Just (op v1 v2)
        _                  -> Nothing
evalBinaryOp _ _ _ = Nothing

otherCall :: Env -> String -> [Ast] -> (Maybe Int, Env)
otherCall env@[] _ _ = (Nothing, env)
otherCall env@((sym, _):rest) f args
    | sym == f = evalCall env f args
    | otherwise = otherCall rest f args

evalLambda :: Env -> [Symbol] -> Ast -> (Maybe Int, Env)
evalLambda env _ _ = (Just 5, env)
