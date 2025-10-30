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
import DataStruct.Lexing (LexedData(Symbol, Number, Text, UnaryOperation, Operation, OpenParenthesis, ClosedParenthesis, VariableDeclaration, Parameter, LexedType, InvokeParameter, Assign, If, While, FuncDef, FuncType, ReturnType, WithParameters, WithVariables, Invoke, AssignResultTo, Display, DisplayNewLine, EndFunction, EndIf, EndWhile, Return, Then, Else), UnaryOperations (BinaryNot, Not, Negate), Operations (Add, Subtract, Multiply, Divide, Modulo, BinaryAnd, BinaryOr, Xor, RightBitshift, LeftBitshift, And, Or, Equal, Different, InferiorOrEqual, SuperiorOrEqual, Inferior, Superior), LexedTypes (LInt, LBoolean, LVoid), VarValue(..), FuncTypes (Function, Main))
import Data.Either (isLeft, isRight)

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
            Right (VariableDeclaration "compteur" LInt (Int 49)),
    "readOptionalComboWords Test 1" ~: (parse (readOptionalComboWordsWithValues) ""
        "- meow, de type entier naturel, valant 727 - feur, de type entier naturel, valant 69 ") ~?=
            Right ([VariableDeclaration "meow" LInt (Int 727),
                VariableDeclaration "feur" LInt (Int 69)]),
    "readOptionalComboWords Test 2" ~: (parse (readOptionalComboWordsWithValues) ""
        "") ~?=
            Right ([]),
    "readComboWord Test 1" ~: (parse (readComboWord) ""
        "- meow, de type booléen") ~?= Right (Parameter "meow" LBoolean),
    "readOptionalComboWords Test 1" ~: (parse (readOptionalComboWords) ""
        "- meow, de type booléen  - feur, de type entier naturel ") ~?=
            Right [Parameter "meow" LBoolean,Parameter "feur" LInt],
    "readOptionalComboWords Test 2" ~: (parse (readOptionalComboWords) ""
        "") ~?=
            Right [],
    "tryReadOne Test 1" ~: parse (tryReadOne [([SString "69"], Symbol "waw"),
        ([SString "727"], Symbol "ok"), ([SString "feur"], Symbol "woohoo")])
        "" "feur" ~?= Right (Symbol "woohoo"),
    "tryReadStrings Test 1" ~:
        isRight (parse (tryReadStrings ["feur", "coubeh", "yes"]) "" "yes")
        ~? "Expected to be parsed correctly",
    "tryReadStrings Test 2" ~:
        isRight (parse (tryReadStrings ["feur", "coubeh", "yes"]) "" "coubeh")
        ~? "Expected to be parsed correctly",
    "tryReadStrings Test 3" ~:
        isLeft (parse (tryReadStrings ["feur", "coubeh", "yes"]) "" "meow")
        ~? "Expected to fail",
    "readFunctionType Test 1" ~:
        parse (readFunctionType) "" "nul" ~?= Right (LexedType LVoid),
    "readMultipleWords Test 1" ~:
        parse (readMultipleWords) "" "meow, feur, coubeh, xd" ~?=
            Right ([Symbol "meow", Symbol "feur", Symbol "coubeh",
                Symbol "xd"]),
    "readMultipleComputables Test 1" ~:
        parse (readMultipleComputables) ""
            "meow, feur, coubeh, 2 plus (1 fois 2)" ~?=
            Right ([InvokeParameter [Symbol "meow"],
                InvokeParameter [Symbol "feur"],
                InvokeParameter [Symbol "coubeh"],
                InvokeParameter [Number 2, Operation Add, OpenParenthesis,
                Number 1, Operation Multiply, Number 2, ClosedParenthesis]]),
    "readAssign Test 1" ~:
        parse (readAssign) "" "x prend la valeur 69." ~?=
            Right [Assign, Symbol "x", Number 69],
    "readAssign Test 2" ~:
        parse (readAssign) "" "J'aimerais que x prenne la valeur 68 fois 2." ~?=
            Right [Assign, Symbol "x", Number 68, Operation Multiply, Number 2],
    "readIf Test 1" ~:
        parse (readIfCondition) ""
        "Si x est égale à (2 fois 5), exécute le texte :"
        ~?= Right [If, Symbol "x", Operation Equal, OpenParenthesis, Number 2,
                Operation Multiply, Number 5, ClosedParenthesis],
    "readWhile Test 1" ~:
        parse (readWhileCondition) ""
        "Tant que x est égale à (2 fois 5) exécute le code ci-après :"
        ~?= Right [While, Symbol "x", Operation Equal, OpenParenthesis, Number 2,
                Operation Multiply, Number 5, ClosedParenthesis],
    "readFunctionDefinition Test 1" ~:
        parse (readFunctionDefinition) ""
        "J'aimerais définir le bloc répondant au nom de meow, de type \
        \de retour entier naturel, nécessitant comme entrée : \
        \- feur, de type booléen ; contenant les variables : \
        \- ok, de type entier naturel, valant 727 ; \
        \représenté par le code suivant."
         ~?= Right [FuncDef,FuncType Function,Symbol "meow",
                    ReturnType,LexedType LInt,
                    WithParameters,Parameter "feur" LBoolean,
                    WithVariables,VariableDeclaration "ok" LInt (Int 727)],
    "readFunctionDefinition Test 1" ~:
        parse (readFunctionDefinition) ""
        "J'aimerais définir le bloc répondant au nom de meow, de type \
        \de retour entier naturel, nécessitant comme entrée : \
        \- feur, de type booléen ; contenant les variables : \
        \- ok, de type entier naturel, valant 727 ; \
        \représenté par le code ci-dessous."
         ~?= Right [FuncDef,FuncType Function,Symbol "meow",
                    ReturnType,LexedType LInt,
                    WithParameters,Parameter "feur" LBoolean,
                    WithVariables,VariableDeclaration "ok" LInt (Int 727)],
    "readInvoke Test 1" ~:
        parse (readInvoke) "" "J'invoque le bloc meow." ~?= Right [Invoke,Symbol "meow"],
    "readInvoke Test 2" ~:
        parse (readInvoke) ""
            "J'invoque le bloc meow, avec les paramètres x, 12 plus 5, y." ~?=
            Right [Invoke,Symbol "meow",WithParameters,
            InvokeParameter [Symbol "x"],
            InvokeParameter [Number 12,Operation Add,Number 5],
            InvokeParameter [Symbol "y"]],
    "readInvoke Test 3" ~:
        parse (readInvoke) ""
        "J'invoque le bloc meow, et j'assigne la valeur de retour \
        \à la variable z." ~?= Right [Invoke,Symbol "meow",AssignResultTo,
        Symbol "z"],
    "readInvoke Test 4" ~:
        parse (readInvoke) "" "J'invoque le bloc meow, et j'assigne la valeur \
        \de retour à la variable x, avec les paramètres jaime, miauler." ~?=
            Right [Invoke,Symbol "meow",AssignResultTo,Symbol "x",
            WithParameters,InvokeParameter [Symbol "jaime"],
            InvokeParameter [Symbol "miauler"]],
    "readDisplay Test 1" ~:
        parse (readDisplay) "" "Affiche 68 plus 1." ~?= Right [Display,
            Number 68, Operation Add, Number 1],
    "readDisplay Test 2" ~:
        parse (readDisplay) "" "Affiche « meow »." ~?=
            Right [Display, Text "meow"],
    "readDisplay Test 3" ~:
        parse (readDisplay) "" "Affiche un retour à la ligne." ~?=
            Right [DisplayNewLine],
    "readMainFunction Test 1" ~:
        parse (readMainFunctionDefinition) ""
        "En sachant que les variables principales sont : ; \
        \pourrais-tu s'il te plaît commencer la lecture ici ?"
        ~?= Right [FuncDef, FuncType Main, WithVariables],
    "readMainFunctionEnd Test 1" ~:
        parse (readMainFunctionEnd) ""
        "Merci d'avance, Cordialement, TheBest\nMeower\n" ~?=
            Right [EndFunction],
    "readFunctionEnd Test 1" ~:
        parse (readFunctionEnd) "" "Merci." ~?=
            Right [EndFunction],
    "readIfEnd Test 1" ~:
        parse (readIfEnd) "" "Merci." ~?=
            Right [EndIf],
    "readWhileEnd Test 1" ~:
        parse (readWhileEnd) "" "Merci." ~?=
            Right [EndWhile],
    "readReturn Test 1" ~:
        parse (readReturn) "" "Enfin, renvoie 69." ~?=
            Right [Return, Number 69],
    "readReturn Test 2" ~:
        parse (readReturn) "" "Enfin, sors du bloc." ~?=
            Right [Return],
    "readIf Test 1" ~:
        parse (readIf) ""
        "Si x est égale à 5, exécute le texte : Affiche 69. Merci." ~?=
            Right [If,Symbol "x",Operation Equal,Number 5,Then,
            Display,Number 69,EndIf],
    "readIf Test 2" ~:
        parse (readIf) ""
        "Si x est égale à 5, exécute le texte : Affiche 69. ; \
        \sinon, exécute le texte : Affiche 727. Merci." ~?=
        Right [If,Symbol "x",Operation Equal,Number 5,Then,
            Display,Number 69,Else,Display,Number 727,EndIf],
    "readWhile Test 1" ~:
        parse (readWhile) ""
        "Tant que x est égale à 5 exécute le code ci-après : Affiche 69. Merci." ~?=
            Right [While,Symbol "x",Operation Equal,Number 5,Then,
            Display,Number 69,EndWhile],
    "readFunction Test 1" ~:
        parse (readFunction) ""
        "J'aimerais définir le bloc répondant au nom de meow, de type \
        \de retour entier naturel, nécessitant comme entrée : \
        \- feur, de type booléen ; contenant les variables : \
        \- ok, de type entier naturel, valant 727 ; \
        \représenté par le code suivant. Affiche 69. Merci."
         ~?= Right [FuncDef,FuncType Function,Symbol "meow",
                    ReturnType,LexedType LInt,
                    WithParameters,Parameter "feur" LBoolean,
                    WithVariables,VariableDeclaration "ok" LInt (Int 727),
                    Display, Number 69, EndFunction],
    "readHi Test 1" ~:
        isRight (parse (readHi) "" "Bonjour,") ~? "Not supposed to fail",
    "readMainFunction Test 1" ~:
        parse (readMainFunction) ""
        "En sachant que les variables principales sont : ; \
        \pourrais-tu s'il te plaît commencer la lecture ici ? Affiche 727. \
        \Merci d'avance, Cordialement, TheBest\nJett EUW\n"
        ~?= Right [FuncDef, FuncType Main, WithVariables,
        Display, Number 727, EndFunction],
    "readCode Test 1" ~:
        parse (readCode) ""
        "Bonjour, En sachant que les variables principales sont : ; \
        \pourrais-tu s'il te plaît commencer la lecture ici ? Affiche 727. \
        \Merci d'avance, Cordialement, TheBest\nJett EUW\n \
        \J'aimerais définir le bloc répondant au nom de meow, de type \
        \de retour entier naturel, nécessitant comme entrée : \
        \- feur, de type booléen ; contenant les variables : \
        \- ok, de type entier naturel, valant 727 ; \
        \représenté par le code suivant. Affiche 69. Merci."
        ~?= Right [FuncDef,FuncType Main,WithVariables,
            Display,Number 727,EndFunction,
            FuncDef,FuncType Function,Symbol "meow",
            ReturnType,LexedType LInt,
            WithParameters,Parameter "feur" LBoolean,
            WithVariables,VariableDeclaration "ok" LInt (Int 727),
            Display,Number 69,EndFunction],
    "lexSyntax Test 1" ~:
        parse (lexSyntax [Word] *> getInput) "" "meow, feur" ~?=
            Right ", feur",
    "lexSyntax Test 2" ~:
        parse (lexSyntax [Word]) "" "meow, feur" ~?= Right (),
    "lexSyntax Test 3" ~:
        parse (lexSyntax [Value, Space, Condition] *> getInput) "" "69 x plus 3 feur" ~?=
            Right " feur",
   "lexSyntax Test 4" ~:
        parse (lexSyntax [OptionalComboWords] *> getInput) "" "j'adore le fromage" ~?=
            Right "j'adore le fromage",
   "lexSyntax Test 5" ~:
        parse (lexSyntax [OptionalComboWords] *> getInput) ""
            "- x, de type booléen meow" ~?= Right "meow",
   "lexSyntax Test 6" ~:
        parse (lexSyntax [OptionalComboWordsWithValue] *> getInput) ""
            "- x, de type booléen, valant 69 \
            \- y, de type entier naturel, valant 727 OWO" ~?= Right "OWO",
    "lexSyntax Test 7" ~:
        parse (lexSyntax [ComboWord, OptionalSpace] *> getInput) "" "- x, de type booléen ok"
            ~?= Right "ok",
    "lexSyntax Test 8" ~:
        parse (lexSyntax [MultipleSString ["Wow", "xD", "Feur"], Space, Name,
            Placeholder (Symbol "x")] *> getInput)
            "" "xD lol\nneed u by my side" ~?= Right "need u by my side",
    "lexSyntax Test 9" ~:
        parse (lexSyntax [WordFunctionType, Space, WordVariableType, Space,
            QuotedValue, Placeholder (Symbol "x")] *> getInput)
            "" "nul entier naturel « yay » allez" ~?= Right " allez",
    "lexSyntax Test 10" ~:
        parse (lexSyntax [MultipleComputables] *> getInput)
            "" "2 plus 1, x, 4 i<3osu" ~?= Right " i<3osu",
    "lexSyntax Test 11" ~:
        parse (lexSyntax [MultipleWords] *> getInput)
            "" "fromage, beurre, pizza, omelette xD" ~?= Right " xD",
    "lexStringsWithTokens' Test 1" ~:
        parse (lexStringsWithTokens' []
            [ComboWord, OptionalSpace, Placeholder (Number 69)])
            "" "- x, de type entier naturel " ~?= Right [Parameter "x" LInt, Number 69],
    "lexStringsWithTokens' Test 2" ~:
        parse (lexStringsWithTokens' []
            [MultipleWords])
            "" "x, feur, meow" ~?= Right [Symbol "x", Symbol "feur", Symbol "meow"]
  ]
