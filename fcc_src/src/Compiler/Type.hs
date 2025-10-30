{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler type
-}

module Compiler.Type (Context (..)
                     , baseContext
                     , Compiler, combine
                     , prefixCompiler
                     , suffixCompiler
                     , mapCompiler
                     , insertVariable
                     , getVariable
                     , varExist
                     , (+>)
                     , (<+)
                     , (.+)
                     , (<@)
                     , (@>)
                     , takeLabel
                     , apply
                     , revCompiler
                     , compileMaybe
                     , funcToContext
                     , isFuncAlreadyDefined
                     , mainFuncContext
                     , callToContext
                     , FunctionContext (..)
                     , funcNameToContext
                     , f2c, f2cf
                     ) where
import Compiler.Variable (VariableStorage, insertVariable'
                         , Variable, getVariable', varExist')
import DataStruct.Asm (Instruction, VariableName, Addr, LabelName)
import DataStruct.Ast.Ast (FunctionName, IsReturning, FunctionDef (Function))
import Error.MaybeError (MaybeError (..))
import Data.Maybe (isJust)

data FunctionContext = FunctionContext { funcName :: !FunctionName
                                       , returning :: !IsReturning
                                       , paramCount :: !Int
                                       }
  deriving (Eq)

instance Show FunctionContext where
  show (FunctionContext name True _) = "<" ++ Prelude.show name ++ ">"
  show (FunctionContext name False _) = Prelude.show name

mainFuncContext :: FunctionContext
mainFuncContext = FunctionContext "main" True 0

data Context = Context
  { var :: !VariableStorage
  , labelCount :: !Int
  , functionDefs :: ![FunctionContext]
  , functionCalls :: ![FunctionContext]
  }
  deriving (Show, Eq)

funcNameToContext :: FunctionName -> Bool -> FunctionContext
funcNameToContext name = flip (FunctionContext name) 0

f2c :: [FunctionName] -> [FunctionContext]
f2c = map $ flip funcNameToContext True

f2cf :: [FunctionName] -> [FunctionContext]
f2cf = map $ flip funcNameToContext False

isFuncAlreadyDefined :: Context -> FunctionName -> Bool
isFuncAlreadyDefined c name = elem name funcContext
  where funcContext = map funcName $ functionDefs c

funcToContext :: Context -> FunctionDef -> Context
funcToContext c (Function name isreturning args _ _) =
  c { functionDefs = (FunctionContext name isreturning l) : functionDefs c }
  where l = length args

callToContext :: Context -> FunctionName -> [a] -> Maybe b -> Context
callToContext c name args r = c { functionCalls = context : functionCalls c }
  where context = FunctionContext name (isJust r) l
        l = length args

varExist :: Context -> VariableName -> Bool
varExist = varExist' . var

takeLabel :: LabelName -> Context -> (Context, LabelName)
takeLabel prefix c = (c { labelCount = n + 1 },name)
  where n = labelCount c
        name = prefix ++ "_" ++ (show n)

baseContext :: Context
baseContext = Context [] 0 [] []

type Compiler a = Context -> a -> MaybeError (Context, [Instruction])

{-
combine :: Compiler a -> a -> Compiler b -> b
  -> VariableStorage -> Maybe (VariableStorage, [Instruction])
combine ca a cb b s = ra >>= (\(s',ra') -> compile cb b s'
                               >>= (\(s'',rb') -> Just (s'',ra' ++ rb')))
  where ra = compile ca a s

combine :: Compiler a -> Compiler b -> Compiler (a,b)
combine ca cb =
  \s (a,b) -> ca s a >>= (
    \(s',ra') -> cb s' b >>= (
      \(s'',rb) -> Just (s'', (ra' ++ rb))))
-}

prefixCompiler :: [Instruction] -> Compiler a -> Compiler a
prefixCompiler i c = \ s a -> case c s a of
  Error t e -> Error t e
  Correct (s', is) -> Correct (s', i ++ is)

suffixCompiler :: [Instruction] -> Compiler a -> Compiler a
suffixCompiler i c = \ s a -> case c s a of
  Error t e -> Error t e
  Correct (s', is) -> Correct (s', is ++ i)

mapCompiler :: Compiler a -> Compiler [a]
mapCompiler ca = (
  \s t -> case t of
    [] -> Correct (s,[])
    (x:xs) -> ca s x >>=
      (\(s',o) -> case mapCompiler ca s' xs of
          Error et e -> Error et e
          Correct (s'', o') -> Correct (s'', o ++ o')))

combine :: Compiler a -> Compiler b -> Compiler (a,b)
combine ca cb = \s (a,b) -> ca s a >>= (\(s',i) -> prefixCompiler i cb s' b)

compileMaybe :: Compiler a -> Compiler (Maybe a)
compileMaybe ca = \s ma -> case ma of
  Nothing -> Correct (s,[])
  Just a -> ca s a

infixl 9 +>

(+>) :: Compiler a -> Compiler b -> Compiler (a,b)
ca +> cb = combine ca cb

infixl 9 <+

(<+) :: a -> b -> (a,b)
a <+ b = (a,b)

infixl 8 .+

(.+) :: (Compiler a, a) -> (Compiler b, b) -> (Compiler (a,b),(a,b))
(ca,a) .+ (cb,b) = (\s (a',b') -> (ca +> cb) s (a',b'), (a,b))

infixl 9 <@

(<@) :: [Instruction] -> (Compiler a, a) -> (Compiler a, a)
i <@ (ca,a) = (prefixCompiler i ca, a)

infixl 9 @>

(@>) :: (Compiler a, a) -> [Instruction] -> (Compiler a, a)
(ca,a) @> i = (suffixCompiler i ca, a)

apply :: (Compiler a,a) -> Context -> MaybeError (Context, [Instruction])
apply (ca,a) s = ca s a

insertVariable :: Context -> Variable -> Context
insertVariable c v = c { var = insertVariable' (var c) v }

getVariable :: Context -> VariableName -> MaybeError Addr
getVariable c = getVariable' (var c)

revCompiler :: Compiler [a] -> Compiler [a]
revCompiler ca = (\s l -> ca s $ reverse l)
