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
execLisp :: Ast -> Env -> (String, Env)
execLisp ast env = evalAst env ast 

evalAst :: Env -> Ast -> (String, Env)
evalAst env ast =
    case ast of
        Value x -> (show x,env)
        ASymbol s -> lookupTable env env s
        Define sym a -> defineSym env sym a
        Lambda _ _ -> ("Lambda", env)
        Call _ _ -> ("call", env)

-- Check if the Symbol already exist
lookupTable :: Env -> Env -> String -> (String, Env)
lookupTable [] e tar = ("Exception: variable " ++ tar ++ " is not bound", e)
lookupTable ((sym, val):rest) e target
    | sym == target = evalAst e val
    | otherwise = lookupTable rest e target

-- Define Symbol and keep it with env variable 
defineSym :: Env -> Symbol -> Ast -> (String, Env)
defineSym env s a = ("", env ++ [(s,a)])
