{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc main
-}

module Main (main) where

import ArgParser (getMyArgs, Arguments (Arguments, input, output))
import Error.MaybeError (printMaybeError, MaybeError (..))
import Error.ErrorList (fileError)
import Data.Functor ((<&>))
import GHC.IO.Exception (IOException(IOError))
import Data.Maybe (fromMaybe)

import DataStruct.Ast.Ast as Ast
import DataStruct.Ast.Type as T
import DataStruct.Ast.Variable as V
import Combinor.Ast (combineAst)
import Compiler.Ast (compile)
import ByteCode.AsmToBytecode (asmToBytecode)
import Binary.InstructionToAsm (instructionToAsm)
import Data.Word (Word8)
import DataStruct.Asm (Instruction)
import Control.Exception (try)
import Debug.Trace (trace)
import Lexer.Lexer (readCode)
import Text.Megaparsec (parse, errorBundlePretty)

readAllFiles :: (MaybeError Arguments) -> IO (MaybeError [(String, String)])
readAllFiles a = sequence
  (a <&>
   (\a' -> (mapM (\file -> (,) <$> readFile file <*> return file) $ input a')))

manageIoError :: IOException -> MaybeError a
manageIoError (IOError _ _ _ _ _ file) = Error fileError (fromMaybe "" file)

checkErrors :: IO (MaybeError a) -> IO (MaybeError a)
checkErrors x = try x <&>
  (\err -> case err of
             Left e -> manageIoError e
             Right a -> a
  )

-- Lexing :D
-- TEMPORARY
-- TODO: Remove when parsing is implemented !
-- Will make the CodingStyle FAIL !
parseArgs :: (String, String) -> MaybeError Ast
parseArgs (content,name) =
  trace (case parse readCode name content of
           Left a -> errorBundlePretty a
           Right b -> show b
        ) $ Correct
  $
  Ast
  -- MAIN --
  (Just $ Main
   -- Main Variables
   []
   -- Main Content
   [ Invoke "foo" [Ast.Value $ V.Int 42, Ast.Value $ V.Int 1] Nothing
   , Invoke "foo"
     [ Ast.Operation $ Ast.BinaryOperation Ast.Add
       (Ast.Value $ V.Int 48)
       (Ast.Value $ V.Int 5)
     , Ast.Value $ V.Int 2
     ] Nothing
   , Invoke "bar" [Ast.Value $ V.Int 5] Nothing
   ])
  -- OTHER FUNCS --
  [ Ast.Function "foo" V.Void
    -- FOO Params
    [ V.FuncParam "a" T.Int, V.FuncParam "b" T.Int ]
    -- FOO Variables
    [ VariableDef "c" T.Int $ V.Int 0 ]
    -- FOO Content
    [ Assign "c" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "a")
        (Ast.Variable "b")
    , Assign "c" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "c")
        (Ast.Value $ V.Int 1)
    , Show $ Ast.Variable "c"
    ]
  , Ast.Function "bar" V.Void
    -- BAR PARAMS
    [V.FuncParam "a" T.Int]
    -- BAR VARIABLES
    [VariableDef "b" T.Int $ V.Int 0]
    -- BAR BODY
    [ Assign "b" $ Ast.Value $ V.Int 48
    , Assign "b" $ Ast.Operation
      $ Ast.BinaryOperation
        Ast.Add
        (Ast.Variable "a")
        (Ast.Variable "b")
    , Invoke "foo" [ Ast.Variable "b", Ast.Value $ V.Int (-1) ] Nothing
    ]
  ]

w2c :: Word8 -> Char
w2c w = toEnum c
  where c = fromEnum w

writeBytecode :: Arguments -> [Word8] -> IO ()
writeBytecode args l = writeFile (output args) (map w2c l)

writeOutput :: (Arguments, [Instruction]) -> IO ()
writeOutput (a@(Arguments _ outputFile _ isDebug),l)
    | isDebug = writeFile outputFile $ instructionToAsm l
    | otherwise = writeBytecode a $ asmToBytecode [] l

main :: IO ()
main = do
  args <- getMyArgs
  readArgs <- checkErrors $ readAllFiles args
  let asm = readArgs >>= (mapM parseArgs) >>= combineAst >>= compile
  let param = (,) <$> args <*> asm
  printMaybeError writeOutput param
