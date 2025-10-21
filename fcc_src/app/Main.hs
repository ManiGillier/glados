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
import Data.ByteString as B (pack, writeFile)

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
import Debug.Trace (trace, traceShowId)
import Lexer.Lexer (readCode)
import Text.Megaparsec (parse, errorBundlePretty)
import DataStruct.Lexing (LexedData)
import Parser.Parser (buildAst)

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

parser :: [LexedData] -> Ast
parser = buildAst

-- Lexing :D
-- TEMPORARY
-- TODO: Remove when parsing is implemented !
-- Will make the CodingStyle FAIL !
parseArgs :: (String, String) -> MaybeError Ast
parseArgs l = parser <$> (traceShowId $ lexer l)

writeBytecode :: Arguments -> [Word8] -> IO ()
writeBytecode args l = B.writeFile (output args) (pack l)

writeOutput :: (Arguments, [Instruction]) -> IO ()
writeOutput (a@(Arguments _ outputFile _ isDebug),l)
    | isDebug = Prelude.writeFile outputFile $ instructionToAsm l
    | otherwise = writeBytecode a $ asmToBytecode l

main :: IO ()
main = do
  args <- getMyArgs
  readArgs <- checkErrors $ readAllFiles args
  let asm = (traceShowId $ readArgs >>= (mapM parseArgs)) >>= combineAst >>= compile
  let param = (,) <$> args <*> asm
  printMaybeError writeOutput param
