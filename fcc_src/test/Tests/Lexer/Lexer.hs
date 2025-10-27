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
import DataStruct.Lexing (LexedData(Symbol, Number, Text, UnaryOperation, Operation, OpenParenthesis, ClosedParenthesis, VariableDeclaration), UnaryOperations (BinaryNot, Not, Negate), Operations (Add, Subtract, Multiply, Divide, Modulo, BinaryAnd, BinaryOr, Xor, RightBitshift, LeftBitshift, And, Or, Equal, Different, InferiorOrEqual, SuperiorOrEqual, Inferior, Superior), LexedTypes (LInt), VarValue(..))
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
        Right (Number 0),
    "readValue Test 13 (Invalid)" ~: (isLeft (parse (readValue) "" "meow")) ~?
        "Expected a parsing error",
    "readValue Test 14 (Invalid)" ~: (isLeft (parse (readValue) "" "-69")) ~?
        "Expected a parsing error",
    "readCharValue Test 1" ~: (parse (readCharValue) "" "'\0' !") ~?=
        Right '\0',
    "escapeList Test 1" ~: (parse (escapeList) "" "0 !") ~?=
        Right '\0',
    "escapeList Test 2" ~: (parse (escapeList) "" "n !") ~?=
        Right '\n',
    "escapeList Test 3" ~: (parse (escapeList) "" "t !") ~?=
        Right '\t',
    "escapeList Test 4" ~: (parse (escapeList) "" "r !") ~?=
        Right '\r',
    "escapeList Test 5" ~: (parse (escapeList) "" "\" !") ~?=
        Right '\"',
    "readQuotedValue Test 1" ~: (parse (readQuotedValue) ""
        "« J'aime les glaces. »") ~?= Right (Text "J'aime les glaces."),
    "readName Test 1" ~: (parse (readName) "" "Mani Gillier Le Goat\n") ~?=
        Right (Symbol "Mani Gillier Le Goat"),
    "readComment Test 1" ~: (parse (readComment *> getInput) ""
        "*Ceci est un joli commentaire* Envie de manger") ~?=
            Right " Envie de manger",
    "readComment Test 2" ~: (parse (readComment) ""
        "*Ceci est un joli commentaire* Envie de manger") ~?=
            Right [],
    "readUnaryOperation Test 1" ~: (parse (readUnaryOperation) "" "~") ~?=
        Right (UnaryOperation BinaryNot),
    "readUnaryOperation Test 2" ~: (parse (readUnaryOperation) "" "non ") ~?=
        Right (UnaryOperation Not),
    "readUnaryOperation Test 3" ~: (parse (readUnaryOperation) "" "-") ~?=
        Right (UnaryOperation Negate),
    "readOperation Test 1" ~: (parse (readOperation) "" "plus") ~?=
        Right (Operation Add),
    "readOperation Test 2" ~: (parse (readOperation) "" "moins") ~?=
        Right (Operation Subtract),
    "readOperation Test 3" ~: (parse (readOperation) "" "fois") ~?=
        Right (Operation Multiply),
    "readOperation Test 4" ~: (parse (readOperation) "" "multiplié    par") ~?=
        Right (Operation Multiply),
    "readOperation Test 5" ~: (parse (readOperation) "" "divisé    par") ~?=
        Right (Operation Divide),
    "readOperation Test 6" ~: (parse (readOperation) "" "modulo") ~?=
        Right (Operation Modulo),
    "readOperation Test 7" ~: (parse (readOperation) "" "et    binaire") ~?=
        Right (Operation BinaryAnd),
    "readOperation Test 8" ~: (parse (readOperation) "" "ou    binaire") ~?=
        Right (Operation BinaryOr),
    "readOperation Test 9" ~: (parse (readOperation) "" "ou    exclusif") ~?=
        Right (Operation Xor),
    "readOperation Test 10" ~: (parse (readOperation) "" "xor") ~?=
        Right (Operation Xor),
    "readOperation Test 11" ~: (parse (readOperation) "" "et") ~?=
        Right (Operation And),
    "readOperation Test 12" ~: (parse (readOperation) "" "ou") ~?=
        Right (Operation Or),
    "readOperation Test 13" ~: (parse (readOperation) ""
        "décalé        binairement     à     gauche") ~?=
        Right (Operation LeftBitshift),
    "readOperation Test 14" ~: (parse (readOperation) ""
        "décalé        binairement     à     droite") ~?=
        Right (Operation RightBitshift),
    "readComparator Test 1" ~: (parse (readComparator) ""
        "est   égale    à" ~?= Right (Operation Equal)),
    "readComparator Test 2" ~: (parse (readComparator) ""
        "est   différent    de" ~?= Right (Operation Different)),
    "readComparator Test 3" ~: (parse (readComparator) ""
        "est   inférieure     ou     égale   à" ~?=
            Right (Operation InferiorOrEqual)),
    "readComparator Test 3" ~: (parse (readComparator) ""
        "est   supérieure     ou     égale   à" ~?=
            Right (Operation SuperiorOrEqual)),
    "readComparator Test 4" ~: (parse (readComparator) ""
        "est      inférieure   à" ~?=
            Right (Operation Inferior)),
    "readComparator Test 5" ~: (parse (readComparator) ""
        "est      supérieure   à" ~?=
            Right (Operation Superior)),
    "readComparator Test 6" ~: (parse (readComparator) ""
        "est" ~?=
            Right (Operation Equal)),
    "readParenthesisComputable Test 1" ~: (parse (readParenthesisComputable) ""
        "(2 plus 3 moins 4 fois 2)") ~?=
            Right [OpenParenthesis,Number 2,Operation Add,Number 3,
                Operation Subtract,Number 4,Operation Multiply,Number 2,
                ClosedParenthesis],
    "readComputableAfterOperationWithUnaryOperation Test 1" ~:
        (parse (readComputableAfterOperationWithUnaryOperation) ""
        "~ 2") ~?= Right [UnaryOperation BinaryNot,Number 2],
    "readComputableAfterOperationWithUnaryOperation Test 2" ~:
        (parse (readComputableAfterOperationWithUnaryOperation) ""
        "~ x") ~?= Right [UnaryOperation BinaryNot,Symbol "x"],
    "readComputableAfterOperationWithUnaryOperation Test 2" ~:
        (parse (readComputableAfterOperationWithUnaryOperation) ""
        "~ (x plus 2)") ~?=
        Right [UnaryOperation BinaryNot,OpenParenthesis,Symbol "x",
            Operation Add,Number 2,ClosedParenthesis],
    "readComputable Test 1" ~: (parse (readComputable) "" " est inférieure à x" ~?=
        Right [Operation Inferior, Symbol "x"]),
    "readCondition Test 2" ~: (parse (readCondition) ""
        "x est inférieure à 69 et y est vrai") ~?=
            Right [Symbol "x", Operation Inferior, Number 69, Operation And, Symbol "y", Operation Equal,
                Number 1],
    "readComboWordWithValue Test 1" ~: (parse (readComboWordWithValue) ""
        "- compteur, de type entier naturel, valant 49") ~?=
            Right (VariableDeclaration "compteur" LInt (Int 49))
 ]
