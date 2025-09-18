{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- ErrorExec 
-}

module Lisp.Exec.ErrorExec (argsError,
                            nonProcedError,
                            notBoundError,
                            ThrowsError) 
                            where

import Lisp.DataStruct.Ast

data LispError
    = UnboundVar String
    | WrongArgCount Int
    | NonProcedure String
    deriving (Show, Eq)

type ThrowsError = Either LispError

-- Errrors 
argsError :: [a] -> (Maybe Value, Env)
argsError args = errorWithoutStackTrace 
    ("*** ERROR : wrong number of argument of " ++ show (length args))

nonProcedError :: Maybe Int -> (Maybe Value, Env)
nonProcedError (Just x) = errorWithoutStackTrace 
    ("*** ERROR : attempt to apply non-procedure " ++ show x)
nonProcedError Nothing = errorWithoutStackTrace 
    ("*** ERROR : attempt to apply non-procedure")

notBoundError :: String -> (Maybe Value, Env)
notBoundError var = errorWithoutStackTrace
    ("*** ERROR : variable " ++ var ++ " is not bound")
