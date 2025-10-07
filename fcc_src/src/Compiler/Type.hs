{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- compiler type
-}

module Compiler.Type ( Compiler (..), CompilerI
                     , prefixCompiler
                     , suffixCompiler
                     , (.$)
                     ) where
import Compiler.Variable (VariableStorage)
import DataStruct.Asm (Instruction)

 -- type Compiler a = VariableStorage -> a -> Maybe (VariableStorage, [Instruction])

data Compiler a b = Compiler {
        compile :: VariableStorage -> a -> Maybe (VariableStorage, [b])
  }
type CompilerI a = Compiler a Instruction

prefixCompiler :: [b] -> Compiler a b -> Compiler a b
prefixCompiler i c = Compiler $ \ s a -> case compile c s a of
  Nothing -> Nothing
  Just (s', is) -> Just (s', i ++ is)

suffixCompiler :: [b] -> Compiler a b -> Compiler a b
suffixCompiler i c = Compiler $ \ s a -> case compile c s a of
  Nothing -> Nothing
  Just (s', is) -> Just (s', is ++ i)

instance Functor (Compiler a) where
  fmap f ca = Compiler (
    \s a -> case (compile ca) s a of
              Nothing -> Nothing
              Just (s', i) -> Just (s', map f i)
    )

instance Applicative (Compiler a) where
  pure _ = Compiler $ (\s _ -> Just (s,[]))
  liftA2 f ca2 cb = Compiler $ (
        \s a1 -> (compile ca2 s a1) >>= (
          \(s',a2) -> ((compile cb s' a1) >>=
                        (\(s'',b) -> Just (s'',liftA2 f a2 b)))
          ))

infixl 5 .$

(.$) :: Compiler a o -> Compiler b o -> Compiler (a,b) o
ca .$ cb = Compiler $ (\s (a,b) -> compile ca s a >>=
                      (\(s',o0) -> compile cb s' b >>=
                      (\(s'',o1) -> Just (s'',o0++o1))))
