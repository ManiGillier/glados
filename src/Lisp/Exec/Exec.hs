{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- Exec 
-}

module Lisp.Exec.Exec (execLisp) where

import Data.Maybe (fromJust, isJust)
import qualified Lisp.Exec.Builtin as Builtin
import qualified Lisp.Exec.ErrorExec as Error
import Lisp.Ast.Ast

type Defined = [(Symbol, Value)]

data Value = VInt Int
           | VLambda [Symbol] Ast Defined
           deriving (Show)

-- Main function of lisp execution
-- Return result and modified env 
execLisp :: Ast -> Defined -> (String, Defined)
execLisp ast env = 
    let (val, e) = evalAst env ast     
    in case val of
        Just (VInt v) -> (show v, e)
        Just (VLambda _ _ _) -> ("#<procedure>", e) 
        Nothing -> ("",e)

-- Eval case of Ast
evalAst :: Defined -> Ast -> (Maybe Value, Defined)
evalAst env ast =
    case ast of
        Value x -> (Just (VInt x), env)
        ASymbol s -> lookupSymbol env s
        Define sym a -> defineSymbol env sym a
        Call f args -> evalCall env f args
        Lambda params body -> evalLambda env params body
        Apply lambdaExpr args -> evalApply env lambdaExpr args

-- Check if the Symbol already exist
lookupSymbol :: Defined -> String -> (Maybe Value, Defined)
lookupSymbol [] var = Error.notBoundError var
lookupSymbol env@((sym, val):rest) target
    | sym == target = (Just val, env)
    | otherwise =
        let (res, _) = lookupSymbol rest target
        in (res, env)

-- Define Symbol and keep it with env variable 
defineSymbol :: Defined -> Symbol -> Ast -> (Maybe Value, Defined)
defineSymbol env s a = 
    let (maybeVal, newEnv) = evalAst env a
    in case maybeVal of
        Just val -> (Nothing, updateEnv newEnv s val)
        Nothing -> (Nothing, env)

updateEnv :: Defined -> Symbol -> Value -> Defined
updateEnv [] s val = [(s, val)]
updateEnv ((sym, oldVal):rest) s val
    | sym == s = (sym, val) : rest
    | otherwise = (sym, oldVal) : updateEnv rest s val

-- Call buitlin or defined lambda
evalCall :: Defined -> String -> [Ast] -> (Maybe Value, Defined)
evalCall env fName args 
    | isBuiltin fName && (not $ isDefined fName env) 
        = evalBuiltinCall env fName args
    | otherwise = evalUserCall env fName args

isBuiltin :: String -> Bool
isBuiltin s = s `elem` ["+", "-", "*", "div", "mod", "eq?", "<"]

isDefined :: String -> Defined -> Bool
isDefined s env = s `elem` map fst env

-- Call builtin function
evalBuiltinCall :: Defined -> String -> [Ast] -> (Maybe Value, Defined)
evalBuiltinCall env fName args = case fName of
    "+" -> (fmap VInt (evalBinaryOp env Builtin.add args), env)
    "-" -> (fmap VInt (evalBinaryOp env Builtin.sub args), env)
    "*" -> (fmap VInt (evalBinaryOp env Builtin.mul args), env)
    "div" -> (fmap VInt (evalBinaryOp env Builtin.safeDiv args), env)
    "mod" -> (fmap VInt (evalBinaryOp env Builtin.safeMod args), env)
    "eq?" -> (fmap VInt (evalBinaryOp env Builtin.equal args), env)
    "<" -> (fmap VInt (evalBinaryOp env Builtin.infsign args), env)
    _ -> (Nothing, env)

-- Evaluate user-defined functions (lambdas)
evalUserCall :: Defined -> String -> [Ast] -> (Maybe Value, Defined)
evalUserCall env fName args = 
    case lookup fName env of
        Just (VLambda params body closureEnv) -> 
            applyLambda env params body closureEnv args
        Just (VInt x) -> 
            Error.nonProcedError (Just x)
        Nothing -> 
            Error.nonProcedError Nothing

evalBinaryOp :: Defined -> (Int -> Int -> Int) -> [Ast] -> Maybe Int
evalBinaryOp env op [arg1, arg2] =
    case (fst (evalAst env arg1), fst (evalAst env arg2)) of
        (Just (VInt v1), Just (VInt v2)) -> Just (op v1 v2)
        _                                -> Nothing
evalBinaryOp _ _ _ = Nothing

-- Create a lambda
evalLambda :: Defined -> [Symbol] -> Ast -> (Maybe Value, Defined)
evalLambda env params body = (Just (VLambda params body env), env)

-- Apply lambda
applyLambda :: Defined -> [Symbol] -> Ast -> Defined -> [Ast] -> (Maybe Value, Defined)
applyLambda currentEnv params body closureEnv args
    | length params /= length args = Error.argsError args 
    | otherwise = 
        let argValues = map (fst . evalAst currentEnv) args
        in if all isJust argValues
           then let justValues = map fromJust argValues
                    localEnv = zip params justValues ++ closureEnv
                    (result, _) = evalAst localEnv body
                in (result, currentEnv)
           else (Nothing, currentEnv)

-- Apply anonymous Lambda call ex: ((lambda (a b c) (* a (* b c))) 2 2 2)
evalApply :: Defined -> Ast -> [Ast] -> (Maybe Value, Defined)
evalApply env lambdaExpr args = 
    let (maybeLambda, newEnv) = evalAst env lambdaExpr
    in case maybeLambda of
        Just (VLambda params body closureEnv) -> 
            applyLambda newEnv params body closureEnv args
        _ -> (Nothing, newEnv)
