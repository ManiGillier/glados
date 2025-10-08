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
                     , (+>)
                     , (<+)
                     , (.+)
                     , (<@)
                     , (@>)
                     , apply
                     ) where
import Compiler.Variable (VariableStorage, insertVariable'
                         , Variable, getVariable')
import DataStruct.Asm (Instruction, VariableName, Addr)

data Context = Context
  { var :: !VariableStorage
  , labelCount :: !Int }

baseContext :: Context
baseContext = Context [] 0

type Compiler a = Context -> a -> Maybe (Context, [Instruction])

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
  Nothing -> Nothing
  Just (s', is) -> Just (s', i ++ is)

suffixCompiler :: [Instruction] -> Compiler a -> Compiler a
suffixCompiler i c = \ s a -> case c s a of
  Nothing -> Nothing
  Just (s', is) -> Just (s', is ++ i)

mapCompiler :: Compiler a -> Compiler [a]
mapCompiler ca = (
  \s t -> case t of
    [] -> Just (s,[])
    (x:xs) -> ca s x >>=
      (\(s',o) -> case mapCompiler ca s' xs of
          Nothing -> Nothing
          Just (s'', o') -> Just (s'', o ++ o')))

combine :: Compiler a -> Compiler b -> Compiler (a,b)
combine ca cb = \s (a,b) -> ca s a >>= (\(s',i) -> prefixCompiler i cb s' b)

infixl 9 +>

(+>) :: Compiler a -> Compiler b -> Compiler (a,b)
ca +> cb = combine ca cb

infixl 9 <+

(<+) :: a -> b -> (a,b)
a <+ b = (a,b)

infixl 8 .+

(.+) :: (Compiler a, a) -> (Compiler b, b) -> (Compiler (a,b),(a,b))
(ca,a) .+ (cb,b) = (\s _ -> (ca +> cb) s (a,b), (a,b))

infixl 9 <@

(<@) :: (Compiler a, a) -> [Instruction] -> (Compiler a, a)
(ca,a) <@ i = (prefixCompiler i ca, a)

infixl 9 @>

(@>) :: (Compiler a, a) -> [Instruction] -> (Compiler a, a)
(ca,a) @> i = (suffixCompiler i ca, a)

apply :: (Compiler a,a) -> Context -> Maybe (Context, [Instruction])
apply (ca,a) s = ca s a

insertVariable :: Context -> Variable -> Context
insertVariable c v = c { var = insertVariable' (var c) v }

getVariable :: Context -> VariableName -> Maybe Addr
getVariable c = getVariable' (var c)
