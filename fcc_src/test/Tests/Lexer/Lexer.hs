{-
-- EPITECH PROJECT, 2025
-- glados tests
-- File description:
-- Lexer Utils
-}


module Tests.Lexer.Lexer (lexerTest) where

import Text.Megaparsec
import Test.HUnit

import Lexer.Syntax
import Lexer.Lexer
import DataStruct.Lexing (LexedData(Symbol, Number))
import Data.Either (isLeft)

lexerTest :: Test
lexerTest = TestList
  [ "readWord Test 1" ~: (parse (readWord) "" "meow, salut ça va?") ~?=
        Right (Symbol "meow"),
    "readWord Test 2" ~: (isLeft (parse (readWord) "" "")) ~?
        "Expected a parsing error",
    "skipWhitespace Test 1" ~: (parse (skipWhitespace *> readWord) ""
        "       meow, feur") ~?= Right (Symbol "meow"),
    "readValue Test 1 (Decimal)" ~: (parse (readValue) "" "69 salut mec!") ~?=
        Right (Number 69),
    "readValue Test 2 (Bool 1)" ~: (parse (readValue) "" "vrai !") ~?=
        Right (Number 1),
    "readValue Test 3 (Bool 2)" ~: (parse (readValue) "" "vraie !") ~?=
        Right (Number 1),
    "readValue Test 4 (Bool 3)" ~: (parse (readValue) "" "faux !") ~?=
        Right (Number 0),
    "readValue Test 5 (Bool 4)" ~: (parse (readValue) "" "fausse !") ~?=
        Right (Number 0),
    "readValue Test 6 (Char 1)" ~: (parse (readValue) "" "'-' !") ~?=
        Right (Number 45),
    "readValue Test 7 (Char 2)" ~: (parse (readValue) "" "'\n' !") ~?=
        Right (Number 10),
    "readValue Test 7 (Char 2)" ~: (parse (readValue) "" "'\t' !") ~?=
        Right (Number 9),
    "readValue Test 8 (Char 3)" ~: (parse (readValue) "" "'\r' !") ~?=
        Right (Number 13),
    "readValue Test 9 (Char 4)" ~: (parse (readValue) "" "'\\\\' !") ~?=
        Right (Number 92),
    "readValue Test 10 (Char 5)" ~: (parse (readValue) "" "'\\'' !") ~?=
        Right (Number 39),
    "readValue Test 11 (Char 6)" ~: (parse (readValue) "" "'\"'' !") ~?=
        Right (Number 34),
    "readValue Test 12 (Char 7)" ~: (parse (readValue) "" "'\0' !") ~?=
        Right (Number 0)
  ]
