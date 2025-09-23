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
import Error.MaybeError (MaybeError (..))
import Lisp.Exec.SymboleTable
import Lisp.DataStruct.Ast
import Lisp.Exec.Builtin

-- Main function of lisp execution
-- Return result and modified String table 
execLisp :: Ast -> SymTable -> (MaybeError String, SymTable)
execLisp ast env = 
    let (val, e) = evalAst env ast     
    in case val of
        Just (VInt v) -> (Correct (show v), e)
        Just (VBool v) -> (Correct $ boolToSymbol v, e)
        Just (VLambda _ _ _) -> ((Error (Error.procError ++ ">") []), e) 
        Just (VError s) -> (Error s [], e)
        Nothing ->  (Correct [],e)

-- Eval case of Ast
evalAst :: SymTable -> Ast -> (Maybe Value, SymTable)
evalAst env ast =
    case ast of
        Value x -> (Just (VInt x), env)
        Boolean x -> (Just (VBool x), env)
        Symbol s -> lookupSymbol env s
        Define sym a -> defineSymbol env sym a
        Call f args -> evalCall env f args
        Lambda param body -> evalLambda env param body
        Apply lambdaExpr args -> evalApply env lambdaExpr args
        If cond th el -> evalCond env cond th el

-- Eval if -> then -> else
evalCond :: SymTable -> Ast -> Ast -> Ast -> (Maybe Value, SymTable)
evalCond env conditionAst thenBranch elseBranch = 
    let (maybeCondition, newEnv) = evalAst env conditionAst
    in case maybeCondition of
        Just (VBool True) -> evalAst newEnv thenBranch
        Just (VBool False) -> evalAst newEnv elseBranch
        Just (VInt 0) -> evalAst newEnv elseBranch
        Just (VInt _) -> evalAst newEnv thenBranch
        Just (VError err) -> (Just (VError err), newEnv)
        Nothing -> evalAst newEnv elseBranch
        _ -> (Just (VError Error.condError), newEnv)

-- Check if the String already exist
findSymbolVal :: SymTable -> String -> (Maybe Value, SymTable)
findSymbolVal [] var = (Just (VError (Error.notBoundError var)), [])
findSymbolVal env@((sym, val):rest) target
    | sym == target = 
        case val of
            VLambda _ _ _ -> 
                (Just (VError (Error.procError ++ " " ++ target ++ ">")), env)
            _             -> (Just val, env)
    | otherwise =
        let (res, _) = findSymbolVal rest target
        in (res, env)

-- Check if symbol isn't define and is a builtin
lookupSymbol :: SymTable -> String -> (Maybe Value, SymTable)
lookupSymbol table target
    | isBuiltin target && not (target `elem` map fst table) = 
        (Just (VError (Error.procError ++ " " ++ target ++ ">")), table)
    | otherwise = findSymbolVal table target 
 
-- Define String and keep it with env variable 
defineSymbol :: SymTable -> String -> Ast -> (Maybe Value, SymTable)
defineSymbol env s a = 
    let (maybeVal, newEnv) = evalAst env a
    in case maybeVal of
        Just val -> (Nothing, updateEnv newEnv s val)
        Nothing -> (Nothing, env)

updateEnv :: SymTable -> String -> Value -> SymTable
updateEnv [] s val = [(s, val)]
updateEnv ((sym, oldVal):rest) s val
    | sym == s = (sym, val) : rest
    | otherwise = (sym, oldVal) : updateEnv rest s val

-- Call buitlin or defined lambda
evalCall :: SymTable -> String -> [Ast] -> (Maybe Value, SymTable)
evalCall env fName args 
    | isBuiltin fName && (not $ isDefined fName env) 
        = evalBuiltinCall env fName args
    | otherwise = evalUserCall env fName args

isBuiltin :: String -> Bool
isBuiltin s = s `elem` ["+", "-", "*", "div", "mod", "eq?", "<"]

isVariadic :: String -> Bool
isVariadic s = s `elem` ["+", "-", "*"]

isDefined :: String -> SymTable -> Bool
isDefined s env = s `elem` map fst env

boolToSymbol :: Bool -> String
boolToSymbol x
    | x = "#t"
    | otherwise = "#f"

evalBuiltinCall :: SymTable -> String -> [Ast] -> (Maybe Value, SymTable)
evalBuiltinCall env fName args 
    | not (isVariadic fName) && (length args > 2) = 
        (Just (VError $ Error.argsError args 
        ++ " " ++Error.callError fName args), env)
    | otherwise = callBuiltin env fName args

callBuiltin :: SymTable -> String -> [Ast] -> (Maybe Value, SymTable)
callBuiltin env fName args = case fName of
        "+" -> (fmap VInt (evalVariadicOp env (+) 0 args), env)
        "-" -> (fmap VInt (evalVariadicSub env args), env)
        "*" -> (fmap VInt (evalVariadicOp env (*) 1 args), env)
        "div" -> (fmap VInt (evalBinaryOp env Builtin.safeDiv args), env)
        "mod" -> (fmap VInt (evalBinaryOp env Builtin.safeMod args), env)
        "eq?" -> (fmap VBool (iToB (evalBinaryOp env Builtin.equal args)), env)
        "<" -> (fmap VBool (iToB (evalBinaryOp env Builtin.infsign args)), env)
        _ -> (Nothing, env)

evalVariadicOp :: SymTable -> (Int -> Int -> Int) -> Int -> [Ast] -> Maybe Int
evalVariadicOp env op identity args = 
    fmap (foldl op identity) (mapM (evalToInt env) args)

evalVariadicSub :: SymTable -> [Ast] -> Maybe Int
evalVariadicSub _ [] = Nothing
evalVariadicSub env [arg] = 
    case evalToInt env arg of
        Just value -> Just (-value)
        Nothing -> Nothing
evalVariadicSub env (first:rest) = 
    case evalToInt env first of
        Just firstVal -> 
            case mapM (evalToInt env) rest of
                Just restVals -> Just (foldl (-) firstVal restVals)
                Nothing -> Nothing
        Nothing -> Nothing

evalToInt :: SymTable -> Ast -> Maybe Int
evalToInt env ast = 
    case fst (evalAst env ast) of
        Just (VInt v) -> Just v
        _ -> Nothing

-- Evaluate user-defined functions (lambdas)
evalUserCall :: SymTable -> String -> [Ast] -> (Maybe Value, SymTable)
evalUserCall env fName args = 
    case lookup fName env of
        Just (VLambda para body clEnv) -> 
            applyLambda env para body clEnv args fName
        Just (VInt x) -> (Just (VError (Error.nonProcedError (Just x))), env)
        Just (VBool _) -> err 
        Just (VError _) -> err
        Nothing -> err
        where 
            err = (Just (VError (Error.notBoundError fName)), env)

evalBinaryOp :: SymTable -> (Int -> Int -> Int) -> [Ast] -> Maybe Int
evalBinaryOp env op [arg1, arg2] =
    case (fst (evalAst env arg1), fst (evalAst env arg2)) of
        (Just (VInt v1), Just (VInt v2)) -> Just (op v1 v2)
        _                                -> Nothing
evalBinaryOp _ _ _ = Nothing

-- Create a lambda
evalLambda :: SymTable -> [String] -> Ast -> (Maybe Value, SymTable)
evalLambda env param body = (Just (VLambda param body env), env)

-- Apply lambda
applyLambda :: SymTable -> [String] -> Ast -> SymTable -> [Ast] -> String -> (Maybe Value, SymTable)
applyLambda env param body clEnv args funcName
    | length param /= length args = (Just (VError (Error.argsError args)), env)
    | otherwise = let argValues = map (fst . evalAst env) args
        in if all isJust argValues
           then let justValues = map fromJust argValues
                    recursiveEnv = (funcName, VLambda param body clEnv) : clEnv
                    localEnv = zip param justValues ++ recursiveEnv
                    (result, _) = evalAst localEnv body
                in (result, env)
           else (Nothing, env)

-- Apply anonymous Lambda call ex: ((lambda (a b c) (* a (* b c))) 2 2 2)
evalApply :: SymTable -> Ast -> [Ast] -> (Maybe Value, SymTable)
evalApply env lambdaExpr args = 
    let (maybeLambda, newEnv) = evalAst env lambdaExpr
    in case maybeLambda of
        Just (VLambda param body clEnv) -> 
            applyLambdaAnonymous newEnv param body clEnv args
        _ -> (Nothing, newEnv)

applyLambdaAnonymous :: SymTable -> [String] -> Ast -> SymTable -> [Ast] -> (Maybe Value, SymTable)
applyLambdaAnonymous env param body clEnv args
    | length param /= length args = (Just (VError (Error.argsError args)), env)
    | otherwise = 
        let argValues = map (fst . evalAst env) args
        in if all isJust argValues
           then let justValues = map fromJust argValues
                    localEnv = zip param justValues ++ clEnv
                    (result, _) = evalAst localEnv body
                in (result, env)
           else (Nothing, env)
