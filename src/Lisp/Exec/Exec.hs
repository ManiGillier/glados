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

-- Main function of lisp execution
-- Return result and modified env 
execLisp :: Ast -> Env -> (String, Env)
execLisp ast env = 
    let (val, e) = evalAst env ast     
    in case val of
        Just (VInt v) -> (show v, e)
        Just (VLambda _ _ _) -> ("#<procedure>", e) 
        Nothing -> ("",e)

-- Eval case of Ast
evalAst :: Env -> Ast -> (Maybe Value, Env)
evalAst env ast =
    case ast of
        Value x -> (Just (VInt x), env)
        ASymbol s -> lookupSymbol env s
        Define sym a -> defineSymbol env sym a
        Call f args -> evalCall env f args
        Lambda params body -> evalLambda env params body
        Apply lambdaExpr args -> evalApply env lambdaExpr args

-- Check if the Symbol already exist
lookupSymbol :: Env -> String -> (Maybe Value, Env)
lookupSymbol [] var = Error.notBoundError var
lookupSymbol env@((sym, val):rest) target
    | sym == target = (Just val, env)
    | otherwise =
        let (res, _) = lookupSymbol rest target
        in (res, env)

-- Define Symbol and keep it with env variable 
defineSymbol :: Env -> Symbol -> Ast -> (Maybe Value, Env)
defineSymbol env s a = 
    let (maybeVal, newEnv) = evalAst env a
    in case maybeVal of
        Just val -> (Nothing, updateEnv newEnv s val)
        Nothing -> (Nothing, env)

updateEnv :: Env -> Symbol -> Value -> Env
updateEnv [] s val = [(s, val)]
updateEnv ((sym, oldVal):rest) s val
    | sym == s = (sym, val) : rest
    | otherwise = (sym, oldVal) : updateEnv rest s val

-- Call buitlin or defined lambda
evalCall :: Env -> String -> [Ast] -> (Maybe Value, Env)
evalCall env fName args 
    | isBuiltin fName && (not $ isDefined fName env) 
        = evalBuiltinCall env fName args
    | otherwise = evalUserCall env fName args

isBuiltin :: String -> Bool
isBuiltin s = s `elem` ["+", "-", "*", "div", "mod", "eq?", "<"]

isDefined :: String -> Env -> Bool
isDefined s env = s `elem` map fst env

-- Call builtin function
evalBuiltinCall :: Env -> String -> [Ast] -> (Maybe Value, Env)
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
evalUserCall :: Env -> String -> [Ast] -> (Maybe Value, Env)
evalUserCall env fName args = 
    case lookup fName env of
        Just (VLambda params body closureEnv) -> 
            applyLambda env params body closureEnv args
        Just (VInt x) -> 
            Error.nonProcedError (Just x)
        Nothing -> 
            Error.nonProcedError Nothing

evalBinaryOp :: Env -> (Int -> Int -> Int) -> [Ast] -> Maybe Int
evalBinaryOp env op [arg1, arg2] = do
    let (val1, _) = evalAst env arg1
    let (val2, _) = evalAst env arg2
    case (val1, val2) of
        (Just (VInt v1), Just (VInt v2)) -> Just (op v1 v2)
        _                                -> Nothing
evalBinaryOp _ _ _ = Nothing

-- Create a lambda
evalLambda :: Env -> [Symbol] -> Ast -> (Maybe Value, Env)
evalLambda env params body = (Just (VLambda params body env), env)

applyLambda :: Env -> [Symbol] -> Ast -> Env -> [Ast] -> (Maybe Value, Env)
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
evalApply :: Env -> Ast -> [Ast] -> (Maybe Value, Env)
evalApply env lambdaExpr args = 
    let (maybeLambda, newEnv) = evalAst env lambdaExpr
    in case maybeLambda of
        Just (VLambda params body closureEnv) -> 
            applyLambda newEnv params body closureEnv args
        _ -> (Nothing, newEnv)
