{-
-- EPITECH PROJECT, 2025
-- GLaDOS [WSL: Ubuntu-24.04]
-- File description:
-- Lexer
-}

module Lexer.Lexer(skipWhitespace, readWord, readValue, lexSyntaxAndReturn,
    lexStringsWithTokens', lexStringsWithTokens, readAssign, readAssign',
    readCondition, readComputable, readComputables, readIfCondition,
    readParenthesisComputable, readWhileCondition, readFunctionDefinition,
    readFunctionType, readMultipleWords, readInvoke, readQuotedValue,
    readDisplay, readMainFunctionDefinition, readName, readComment,
    readMainFunctionEnd, readFunctionEnd, readWhileEnd, readIfEnd,
    readReturn, readFunction, readFunctionBody, readCode,
    readIf, readMainFunction, readWhile) where

import Lexer.Syntax(Syntax(..), assignNameSyntax, assignValueSyntax,
    assignSyntax, assignSyntax', ifConditionSyntax, whileConditionSyntax,
    functionDefinitionNameSyntax, functionDefinitionReturnTypeSyntax,
    functionDefinitionWithVariablesSyntax, functionDefinitionParametersSyntax,
    functionDefinitionEndSyntax, functionDefinitionReturnsVariableSyntax,
    functionTypes, variableTypes, invokeSyntax, invokeAssignSyntax,
    invokeParametersSyntax, displaySyntax, displaySyntax', displaySyntax'',
    displaySyntax''', mainFunctionSyntax, endMainFunctionSyntax,
    endFunctionSyntax, endIfSyntax, endWhileSyntax, returnSyntax,
    returnSyntax', returnSyntax'', hiSyntax, elseSyntax)

import Data.Void (Void)

import ApplicativeAddons

import DataStruct.Lexing(LexedData(..), Operations(..),
    UnaryOperations(..), FuncTypes(..), VarValue(..))

import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal, signed)
import qualified Text.Megaparsec.Char.Lexer as L

type Lexer = Parsec Void String

skipWhitespace :: Lexer ()
skipWhitespace = space

readWord :: Lexer LexedData
readWord = Symbol <$> some (noneOf " .,\t\n()")

readValue :: Lexer LexedData
readValue =
    Number
        <$> signed (return ()) decimal
        <* notFollowedBy (noneOf " .,\t\n()")

readQuotedValue :: Lexer LexedData
readQuotedValue =
    Text <$> (string "« " *> manyTill L.charLiteral (string " »"))

readName :: Lexer LexedData
readName =
    Symbol <$> manyTill L.charLiteral (char '\n')

readComment :: Lexer [LexedData]
readComment = char '*' *> (manyTill L.charLiteral (char '*')) *> return []

readUnaryOperation :: Lexer LexedData
readUnaryOperation = UnaryOperation <$> choice [
    BinaryNot <$ string "~",
    Not <$ lexSyntax [SString "non", Space],
    Negate <$ char '-']

readOperation :: Lexer LexedData
readOperation = Operation <$> choice [
    arithmeticOperations,
    binaryOperations,
    logicalOperations,
    bitshiftOperations]

arithmeticOperations :: Lexer Operations
arithmeticOperations = choice [
    Add      <$ string "plus",
    Subtract <$ string "moins",
    Multiply <$ string "fois",
    Multiply <$ lexSyntax [SString "multiplié", Space, SString "par"],
    Divide   <$ lexSyntax [SString "divisé", Space, SString "par"],
    Modulo <$ string "modulo"]

binaryOperations :: Lexer Operations
binaryOperations = choice [
    BinaryAnd <$ try (lexSyntax [SString "et", Space, SString "binaire"]),
    BinaryOr <$ try (lexSyntax [SString "ou", Space, SString "binaire"]),
    Xor <$ try (lexSyntax [SString "ou", Space, SString "exclusif"]),
    Xor <$ string "xor"]

logicalOperations :: Lexer Operations
logicalOperations = choice [
    And <$ string "et",
    Or <$ string "ou"]

bitshiftOperations :: Lexer Operations
bitshiftOperations = choice [
    LeftBitshift <$ try (lexSyntax [SString "décalé", Space,
        SString "binairement", Space, SString "à", Space, SString "gauche"]),
    RightBitshift <$ try (lexSyntax [SString "décalé", Space,
        SString "binairement", Space, SString "à", Space, SString "droite"])]

readComparator :: Lexer LexedData
readComparator = Operation <$> choice [
    Equal <$ lexSyntax [SString "égale", Space, SString "à"],
    Different <$ lexSyntax [SString "différent", Space, SString "de"],
    InferiorOrEqual <$ try (lexSyntax [SString "inférieure", Space,
        SString "ou", Space, SString "égale", Space, SString "à"]),
    SuperiorOrEqual <$ try (lexSyntax [SString "supérieure", Space,
        SString "ou", Space, SString "égale", Space, SString "à"]),
    Inferior <$ lexSyntax [SString "inférieure", Space, SString "à"],
    Superior <$ lexSyntax [SString "supérieure", Space, SString "à"]]

readParenthesisComputable :: Lexer [LexedData]
readParenthesisComputable =
  (\inner -> [OpenParenthesis] ++ inner ++ [ClosedParenthesis])
    <$> (char '(' *> space *> (readComputableAfterOperation $++
        (concat <$> many readComputable)) <* (space *> char ')'))

readComputableAfterOperationWithUnaryOperation :: Lexer [LexedData]
readComputableAfterOperationWithUnaryOperation =
    (readUnaryOperation <* skipWhitespace) $: ((try (glob readValue) <|>
    try readParenthesisComputable <|> (glob readWord)))

readComputableAfterOperation :: Lexer [LexedData]
readComputableAfterOperation =  try
    readComputableAfterOperationWithUnaryOperation <|> try (glob readValue) <|>
    try readParenthesisComputable <|> (glob readWord)

readComputable :: Lexer [LexedData]
readComputable = try ((space1 *> string "est" *> space1 *> glob readComparator)
    $++ (space1 *> readComputableAfterOperation)) <|>
    try (space1 *> readOperation $: (space1 *> readComputableAfterOperation))

readComputables :: Lexer [LexedData]
readComputables = concat <$> (readComputableAfterOperation $:
    (many readComputable))

readCondition :: Lexer [LexedData]
readCondition = readComputables

convertToDeclaration :: [LexedData] -> LexedData
convertToDeclaration [Symbol a, LexedType b, Number c] =
    VariableDeclaration a b (Int c)
convertToDeclaration [Symbol a, LexedType b, Text c] =
    VariableDeclaration a b (String c)
convertToDeclaration _ = error "Not supposed to happen..?"

readComboWord :: Lexer LexedData
readComboWord = convertToDeclaration <$> readVariableDeclaration

readVariableDeclaration :: Lexer [LexedData]
readVariableDeclaration = try (lexStringsWithTokens [SString "-", Space, Word,
        SString ",", Space, SString "de", Space, SString "type", Space,
        WordVariableType, SString ",", Space, SString "valant", Space, Value])
        <|> lexStringsWithTokens [SString "-", Space, Word, SString ",", Space,
        SString "de", Space, SString "type", Space, WordVariableType,
        SString ",", Space, SString "valant", Space, QuotedValue]

readOptionalComboWords :: Lexer [LexedData]
readOptionalComboWords = many (readComboWord <* space1)

readEOI :: Lexer Char
readEOI = char '.'

tryReadOne :: [([Syntax], LexedData)] -> Lexer LexedData
tryReadOne [] = error "Nothing to try..?"
tryReadOne [(x, y)] = lexStringsWithTokens x *> return y
tryReadOne ((x,y):xs) = (lexStringsWithTokens x *> return y) <|> tryReadOne xs

tryReadStrings :: [String] -> Lexer [LexedData]
tryReadStrings [] = error "Nothing to try..?"
tryReadStrings [x] = lexStringsWithTokens [SString x]
tryReadStrings (x:xs) = lexStringsWithTokens [SString x] <|> tryReadStrings xs

readFunctionType :: Lexer LexedData
readFunctionType = tryReadOne functionTypes

readVariableType :: Lexer LexedData
readVariableType = tryReadOne variableTypes

readMultipleWords :: Lexer [LexedData]
readMultipleWords = readWord `sepBy` (char ',' *> skipWhitespace)

lexSyntax :: [Syntax] -> Lexer ()
lexSyntax [] = return ()
lexSyntax (Word : xs) = readWord >>= \_ -> lexSyntax xs
lexSyntax (Space : xs) = space1 *> lexSyntax xs
lexSyntax (Value : xs) = readValue >>= \_ -> lexSyntax xs
lexSyntax (Condition : xs) = readCondition >>= \_ -> lexSyntax xs
lexSyntax (ComboWord : xs) = readComboWord >>= \_ -> lexSyntax xs
lexSyntax (OptionalComboWord : xs) = (try readComboWord) >>= \_ -> lexSyntax xs
lexSyntax (OptionalComboWords : xs) = readOptionalComboWords *> lexSyntax xs
lexSyntax (OptionalSpace : xs) = skipWhitespace *> lexSyntax xs
lexSyntax ((SString (x)):xs) = string x *> lexSyntax xs
lexSyntax ((MultipleSString (x) : xs)) = tryReadStrings x *> lexSyntax xs
lexSyntax (Placeholder _ : xs) = lexSyntax xs
lexSyntax (WordFunctionType : xs) = readFunctionType *> lexSyntax xs
lexSyntax (WordVariableType : xs) = readVariableType *> lexSyntax xs
lexSyntax (MultipleWords : xs) = readMultipleWords *> lexSyntax xs
lexSyntax (QuotedValue : xs) = readQuotedValue *> lexSyntax xs
lexSyntax (Name : xs) = readName *> lexSyntax xs

lexSyntaxAndReturn :: [Syntax] -> a -> Lexer a
lexSyntaxAndReturn [] a = return a
lexSyntaxAndReturn (Word : xs) a = readWord >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Space : xs) a = space1 *> lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Value : xs) a = readValue >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Condition : xs) a = readCondition >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn ((SString (x)):xs) a = string x *> lexSyntaxAndReturn xs a
lexSyntaxAndReturn (ComboWord : xs) a = readComboWord >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (OptionalComboWord : xs) a = (try readComboWord) >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (OptionalComboWords : xs) a = (readOptionalComboWords) >>=
    \_ -> lexSyntaxAndReturn xs a
lexSyntaxAndReturn (OptionalSpace : xs) a = skipWhitespace *>
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Placeholder _ : xs) a = lexSyntaxAndReturn xs a
lexSyntaxAndReturn (WordFunctionType : xs) a = readFunctionType >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (WordVariableType : xs) a = readVariableType >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (MultipleSString (x) : xs) a = tryReadStrings x >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (MultipleWords : xs) a = readMultipleWords >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (QuotedValue : xs) a = readQuotedValue >>= \_ ->
    lexSyntaxAndReturn xs a
lexSyntaxAndReturn (Name : xs) a = readName >>= \_ ->
    lexSyntaxAndReturn xs a

lexStringsWithTokens' :: [LexedData] -> [Syntax] -> Lexer [LexedData]
lexStringsWithTokens' t [] = return t
lexStringsWithTokens' t (Word : xs) = readWord >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (Space : xs) = space1 *> lexStringsWithTokens' t xs
lexStringsWithTokens' t (Value : xs) = readValue >>= \toAdd ->
    lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (Condition : xs) = readCondition >>= \toAdd ->
    lexStringsWithTokens' (t ++ toAdd) xs
lexStringsWithTokens' t ((SString (x)):xs) = string x *>
    lexStringsWithTokens' t xs
lexStringsWithTokens' t (ComboWord : xs) = readComboWord >>= \toAdd ->
    lexStringsWithTokens' (toAdd : t) xs
lexStringsWithTokens' t (OptionalComboWord : xs) =
    option [] (fmap (\x -> [x]) readComboWord) >>= \toAdd ->
    lexStringsWithTokens' (t ++ toAdd) xs
lexStringsWithTokens' t (OptionalComboWords : xs) =
    option [] readOptionalComboWords >>= \toAdd ->
    lexStringsWithTokens' (t ++ toAdd) xs
lexStringsWithTokens' t (OptionalSpace : xs) = skipWhitespace *>
    lexStringsWithTokens' t xs
lexStringsWithTokens' t (Placeholder a : xs) =
    lexStringsWithTokens' (t ++ [a]) xs
lexStringsWithTokens' t (WordFunctionType : xs) = readFunctionType >>=
    \toAdd -> lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (WordVariableType : xs) = readVariableType >>=
    \toAdd -> lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (MultipleSString x : xs) = tryReadStrings x >>=
    \toAdd -> lexStringsWithTokens' (t ++ toAdd) xs
lexStringsWithTokens' t (MultipleWords : xs) = readMultipleWords >>=
    \toAdd -> lexStringsWithTokens' (t ++ toAdd) xs
lexStringsWithTokens' t (QuotedValue : xs) = readQuotedValue >>=
    \toAdd -> lexStringsWithTokens' (t ++ [toAdd]) xs
lexStringsWithTokens' t (Name : xs) = readName >>=
    \_ -> lexStringsWithTokens' (t) xs

lexStringsWithTokens :: [Syntax] -> Lexer [LexedData]
lexStringsWithTokens toLex = lexStringsWithTokens' [] toLex

readAssign :: Lexer [LexedData]
readAssign = try (lexStringsWithTokens' [Assign] assignSyntax <* readEOI) <|>
    (lexStringsWithTokens' [Assign] assignSyntax' <* readEOI)

readIfCondition :: Lexer [LexedData]
readIfCondition = lexStringsWithTokens' [If] ifConditionSyntax

readWhileCondition :: Lexer [LexedData]
readWhileCondition = lexStringsWithTokens' [While] whileConditionSyntax

readFunctionDefinition' :: Lexer [LexedData]
readFunctionDefinition' = lexStringsWithTokens' [FuncDef, FuncType Function]
    functionDefinitionNameSyntax $++ lexStringsWithTokens' [ReturnType]
    functionDefinitionReturnTypeSyntax $++ lexStringsWithTokens'
    [WithParameters] functionDefinitionParametersSyntax $++
    lexStringsWithTokens' [WithVariables] functionDefinitionWithVariablesSyntax
    $++ lexStringsWithTokens functionDefinitionEndSyntax

readFunctionDefinition'' :: Lexer [LexedData]
readFunctionDefinition'' = readFunctionDefinition' $++
    lexStringsWithTokens' [Returns] functionDefinitionReturnsVariableSyntax

readFunctionDefinition :: Lexer [LexedData]
readFunctionDefinition = (try readFunctionDefinition'' <|>
    readFunctionDefinition') <* readEOI

readInvoke''' :: Lexer [LexedData]
readInvoke''' = lexStringsWithTokens' [Invoke] invokeSyntax $++
    lexStringsWithTokens' [AssignResultTo] invokeAssignSyntax $++
    lexStringsWithTokens' [WithParameters] invokeParametersSyntax

readInvoke'' :: Lexer [LexedData]
readInvoke'' = lexStringsWithTokens' [Invoke] invokeSyntax $++
    lexStringsWithTokens' [AssignResultTo] invokeAssignSyntax

readInvoke' :: Lexer [LexedData]
readInvoke' = lexStringsWithTokens' [Invoke] invokeSyntax $++
    lexStringsWithTokens' [WithParameters] invokeParametersSyntax

readInvoke :: Lexer [LexedData]
readInvoke = (try readInvoke''' <|> try readInvoke'' <|> try readInvoke' <|>
    lexStringsWithTokens' [Invoke] invokeSyntax) <* readEOI

readDisplay :: Lexer [LexedData]
readDisplay = (try (lexStringsWithTokens' [Display] displaySyntax) <|>
    try (lexStringsWithTokens' [Display] displaySyntax') <|>
    try (lexStringsWithTokens' [DisplayNewLine] displaySyntax'') <|>
    try (lexStringsWithTokens' [Display] displaySyntax''')) <* readEOI

readMainFunctionDefinition :: Lexer [LexedData]
readMainFunctionDefinition = lexStringsWithTokens' [FuncDef, FuncType Main,
    WithVariables] mainFunctionSyntax

readMainFunctionEnd :: Lexer [LexedData]
readMainFunctionEnd = lexStringsWithTokens' [EndFunction] endMainFunctionSyntax

readFunctionEnd :: Lexer [LexedData]
readFunctionEnd = lexStringsWithTokens' [EndFunction] endFunctionSyntax

readIfEnd :: Lexer [LexedData]
readIfEnd = lexStringsWithTokens' [EndIf] endIfSyntax

readWhileEnd :: Lexer [LexedData]
readWhileEnd = lexStringsWithTokens' [EndWhile] endWhileSyntax

readReturn :: Lexer [LexedData]
readReturn = (try (lexStringsWithTokens' [Return] returnSyntax) <|>
    try (lexStringsWithTokens' [Return] returnSyntax') <|>
    lexStringsWithTokens' [Return] returnSyntax'') <* readEOI

readAssign' :: Lexer [LexedData]
readAssign' = (\ws1 ws2 -> Assign : ws1 ++ ws2)
    <$> lexStringsWithTokens assignNameSyntax
    <*> lexStringsWithTokens assignValueSyntax
    <* readEOI

readIfElse :: Lexer [LexedData]
readIfElse = (readIfCondition <* skipWhitespace) $++
    (return [Then]) $++ (readSomeInstructions) $++
    (lexStringsWithTokens' [Else] elseSyntax <* skipWhitespace) $++
    readSomeInstructions $++ readIfEnd

readIf :: Lexer [LexedData]
readIf = try readIfElse <|> (readIfCondition <* skipWhitespace) $++
    (return [Then]) $++ (readSomeInstructions) $++
    (readIfEnd)

readWhile :: Lexer [LexedData]
readWhile = (readWhileCondition <* skipWhitespace) $++
    (return [Then]) $++ (readSomeInstructions) $++
    (readWhileEnd)

readFunctionBody :: Lexer [LexedData]
readFunctionBody =
    try readAssign <|> try readIf <|> try readWhile <|> try readReturn
    <|> try readInvoke <|> try readComment <|> readDisplay

readSomeInstructions :: Lexer [LexedData]
readSomeInstructions = concat <$> some (readFunctionBody <* skipWhitespace)

readFunction :: Lexer [LexedData]
readFunction = (readFunctionDefinition <* skipWhitespace) $++
    (readSomeInstructions) $++
    (readFunctionEnd <* skipWhitespace)

readHi :: Lexer [LexedData]
readHi = lexStringsWithTokens hiSyntax

readMainFunction :: Lexer [LexedData]
readMainFunction = (readMainFunctionDefinition <* skipWhitespace) $++
    (readSomeInstructions) $++
    (readMainFunctionEnd <* skipWhitespace)

readCode :: Lexer [LexedData]
readCode =
    readHi *> space1 *>
    (concat <$> some (try readMainFunction <|> readFunction))
