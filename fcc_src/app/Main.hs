{-
-- EPITECH PROJECT, 2025
-- glados
-- File description:
-- fcc main
-}

module Main (main) where

import ArgParser (getMyArgs, Arguments (Arguments, input, output, larousse))
import Error.MaybeError (printMaybeError, MaybeError (..))
import Error.ErrorList (fileError)
import Data.Functor ((<&>))
import GHC.IO.Exception (IOException(IOError))
import Data.Maybe (fromMaybe)
import Data.ByteString as B (pack, writeFile)

import DataStruct.Ast.Ast as Ast
import Combinor.Ast (combineAst)
import Compiler.Ast (compile)
import ByteCode.AsmToBytecode (asmToBytecode)
import Binary.InstructionToAsm (instructionToAsm)
import Data.Word (Word8)
import DataStruct.Asm (Instruction)
import Control.Exception (try)
import Lexer.Lexer (readCode)
import Text.Megaparsec (parse, errorBundlePretty)
import DataStruct.Lexing (LexedData)
import Parser.Parser (buildAst)
import LarousseGetter (getLarousse)

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

lexer :: (String,String) -> MaybeError [LexedData]
lexer (content,name) = case parse readCode name content of
  Left a -> Error "Parse error" $ errorBundlePretty a
  Right a -> Correct a

parser :: [LexedData] -> MaybeError Ast
parser = buildAst

parseArgs :: (String, String) -> MaybeError Ast
parseArgs l = lexer l >>= parser

writeBytecode :: Arguments -> [Word8] -> IO ()
writeBytecode args l = B.writeFile (output args) (pack l)

writeOutput :: (Arguments, [Instruction]) -> IO ()
writeOutput (a@(Arguments _ outputFile _ isDebug),l)
    | isDebug = Prelude.writeFile outputFile $ instructionToAsm l
    | otherwise = writeBytecode a $ asmToBytecode l

addLarousse :: Arguments -> IO Arguments
addLarousse args
  | larousse args = getLarousse <&> \la -> args { input = input args ++ la }
  | otherwise = return args

main :: IO ()
main = do
  args <- getMyArgs
  args' <- sequenceA $ args <&> addLarousse
  readArgs <- checkErrors $ readAllFiles args'
  let asm = (readArgs >>= (mapM parseArgs)) >>=
        combineAst >>= compile
  let param = (,) <$> args <*> asm
  printMaybeError writeOutput param
