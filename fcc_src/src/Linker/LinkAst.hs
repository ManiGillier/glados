{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- linker
-}

module Linker.LinkAst (link) where

import DataStruct.Ast.Ast (Ast (Ast), CombinedAst (CAst)
                          , MainFunctionDef, FunctionDef)
import Error.MaybeError (MaybeError (Error, Correct))
import Error.ErrorList (alreadyDefFuncErr, noMainErr)

combineFuncs :: [Ast] -> [FunctionDef]
combineFuncs [] = []
combineFuncs ((Ast _ l):xs) = l ++ combineFuncs xs

getMain :: [Ast] -> MaybeError MainFunctionDef
getMain [] = Error noMainErr ""
getMain ((Ast Nothing _):xs) = getMain xs
getMain ((Ast (Just x) _):xs) = case getMain xs of
  Error _ _ -> Correct x
  Correct _ -> Error alreadyDefFuncErr "main"

link :: [Ast] -> MaybeError CombinedAst
link l = (\main -> CAst main $ combineFuncs l) <$> getMain l
