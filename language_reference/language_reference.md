# Motives

-   The **Franc C** was built to allow french people to program in their
    home language.
-   The language is easily readable for a non-technical person.
-   The focus is put on the syntax, not in the functionalities of the
    language.

# Inspirations

We took inspiration for our syntax on a beautiful language,
[linotte](http://langagelinotte.free.fr) ; and for our implementation on
the [C programming language](https://www.iso.org/standard/82075.html).

Obviously, the french language is our biggest inspirator.

## Linotte

The linotte programming language is a high-level,
french-litteral-syntaxed programming language made for introducing
programmation to children.

We saw it as a great inspiration for our language with the next
features:

-   Word delimitation at the end of functions, if and while
    conditionals.
-   Use of some syntax like \"read\" instead of \"execute\" code

The linotte syntax was, however, not litteral enough to our liking.

## C

The C programming language is a low-level language. We took inspiration
from it in the implementation of our language. For example, the C
programming language is from the imperative paradigm, and so is our
language.

We took many things from this language:

-   The imperative paradigm
-   The int-defined booleans In the C programming language, all integers
    can be interpreted as booleans. A false is a value strictly equal to
    zero, and a true is every other values.
-   The possibility of defining variables local to each function call
-   The possibility of using recursive function calls
-   The representation of a chararacter by it\'s ascii value
-   The function used to print a character \"putchar\"
-   The existence of a standard library with some useful functions
-   All of the operations like xor, addition, bitshift...
-   The possibility for functions to return a value
-   The infix notation of operations, with parenthesis
-   The possibility to compute directly with any combination of
    operations in any part of the code where a value is required. For
    example, when passing a parameter, you could pass a computation, a
    variable value, or a mix of both

Many of these features are also present in other languages, but we took
them from our knowledge of the C programming language.

## French language

French is not a programming, but a spoken language.

We wanted a truly grammatically correct, complete, easily readable, and
beautiful language.

Our choice was obviously french, as french syntax is way more precise
than english\'s.

We searched for dozen of grammar rules to inforce in our language.


# Language Formal Syntax (BNF)

```bnf
<header> ::= "Bonjour," <spaces>

<main> ::= "En" <spaces> "sachant" <spaces> "que" <spaces> "les" <spaces> "variables" <spaces> "principales" <spaces> "sont" <spaces> ":" <spaces> [<variable_list>]
 "\;" <spaces> "pourrais-tu" <spaces> "s'il" <spaces> "te" <spaces> "plaît" <spaces> "commencer" <spaces> "la" <spaces> "lecture" <spaces> "ici" <spaces> "?" [<spaces>] <block> [<spaces>] "Merci d'avance," <spaces> "Cordialement," <spaces> <name> <name>

<variable_definition> ::= "-" <spaces> <word> "," <spaces> "de" <spaces> "type" <spaces> <variable_type> "," <spaces> "valant" <spaces> <value> 

<variable_list> ::= <variable_definition> <spaces> [<variable_list>]

<exclusif_or> ::= "ou" <spaces> "exclusif" | "xor"

<arithmetic_operator> ::= "plus" | "moins"
                        | ("divisé" | "multiplié") <spaces> "par"
                        | "modulo"
                        | "fois"

<comparison_operator> ::= "est"
                        | "est" <spaces> "égale" <spaces> "à"
                        | "est" <spaces> "différent" <spaces> "de"
                        | "est" <spaces> "inférieure" <spaces> "à"
                        | "est" <spaces> "supérieure" <spaces> "à"
                        | "est" <spaces> "inférieure" <spaces> "ou" <spaces> "égale" <spaces> "à"
                        | "est" <spaces> "supérieure" <spaces> "ou" <spaces> "égale" <spaces> "à"

<logical_operator> ::= "et" | "ou"

<bitwise_operator> ::= "décalé" <spaces> "binairement" <spaces> "à" <spaces> "gauche"
    | "décalé" <spaces> "binairement" <spaces> "à" <spaces> "droite"
    | "et" <spaces> "binaire"
    | "ou" <spaces> "binaire"
    | <exclusif_or>
 
<operators> ::= <bitwise_operator> | <logical_operator> | <comparison_operator> | <arithmetic_operator>

<parenthesized_condition> ::= "(" <condition> ")"

<condition> ::= <word> [<spaces> <operators> <spaces> (<condition> | <parenthesized_condition>)]
              | <value> [<spaces> <operators> <spaces> (<condition> | <parenthesized_condition>)]

<parameter> ::= "-" <spaces> <word> "," <spaces> "de" <spaces> "type" <spaces> <variable_type>

<parameter_list> ::= <parameter> <spaces> [<parameter_list>]

<function_definition> ::= "J’aimerais" <spaces> "définir" <spaces> "le" <spaces> "bloc" <spaces> "répondant" <spaces> "au" <spaces> "nom" <spaces> "de" <spaces> <word> "," <spaces> "de" <spaces> "type" <spaces> "de" <spaces> "retour" <spaces> <function_type> "," <spaces> "nécessitant" <spaces> "comme" <spaces> "entrée" <spaces> ":" <spaces> [<parameter_list>] "\;" <spaces> "contenant" <spaces> "les" <spaces> "variables" <spaces> ":" <spaces> [<variable_list>] "\;" <spaces> "représenté" <spaces> "par" <spaces> "le" <spaces> "code" <spaces> ("suivant" | "ci-après" | "ci-dessous") "." [<spaces>] <block> <spaces> "Merci."

<text> ::= <symbol> [<text>]

<comment> ::= "*" <text> "*"

<quoted_value> ::= "« " <text> " »"

<block> ::= <statement_list>

<statement_list> ::= <statement> [[<spaces>] <statement_list> [<spaces]]

<statement> ::= <condition_statement> | <return_statement> | <loop_statement> | <display_statement> | <invoke_statement> | <assignment_statement>

<return_statement> ::= "Enfin," <spaces> "renvoie" <spaces> <condition> "." | "Enfin," <spaces> "sors" <spaces> "du" <spaces> "bloc."

<condition_definition> ::= "Si" <spaces> <condition> "," <spaces> "exécute" <spaces> "le" <spaces> "texte" <spaces> ":"

<condition_statement> ::= <condition_definition> <space> <block> "Merci."
    | <condition_definition> <space> <block> "\;" <space> "sinon" <space> "exécute" <space> "le" <space> "texte" <space> ":" <block> "Merci."

<loop_statement> ::= "Tant" <spaces> "que" <condition> <spaces> "exécute" <spaces> "le" <spaces> "code" <spaces> "ci-après" <spaces> ":" <spaces> <block> "Merci."

<display_statement> ::= "Affiche" (<condition> | <quoted_value>) "."

<invoke_params> ::= <condition> ["," <condition>]

<invoke_statement> ::= "J'invoque" <spaces> "le" <spaces> "bloc" <spaces> <word>
    ["," <spaces> "et" <spaces> "j'assigne" <spaces> "la" <spaces> "valeur" <spaces> "de" <spaces> "retour" <spaces> "à" <spaces> "la" <spaces> "variable" <spaces> <word>]
    ["," <spaces> "avec les paramètres" <spaces> <invoke_params>] "."

<assignment_statement> ::= "J'aimerais" <spaces> "que" <spaces> <word> <spaces> "prenne" <spaces> "la" <spaces> "valeur" <spaces> <condition> "." |
    <word> <spaces> "prend" <spaces> "la" <spaces> "valeur" <spaces> <condition>

<variable_type> ::= "entier" <spaces> "naturel" | "booléen"

<function_type> ::= "entier" <spaces> "naturel" | "booléen" | "nul"

<name> ::= <word> "\n"

<variables_list> ::= <variables> | <variables> <spaces> <variables_list>

<variables> ::= <name> "," <spaces> "de" <spaces> "type" <spaces> <type> "," <spaces> "valant" <spaces> <value>

<space> ::= "\t" | "\n" | "\r" | "\f" | "\v"

<spaces> ::= <space> | <space> <spaces>

<number> ::= 0 | 1 | 2 | 3 | ...

<signed_number> ::= "-" <number> | "~" <number> | "non" <spaces> <number>

<value> ::= <signed_number> | <number> | <bool> | <char_value>

<word_char> ::= <printable> | <word_symbol>

<printable> ::= "A" .. "Z"
              | "a" .. "z"
              | "0" .. "9"

<word_symbol> ::= "!" | "\"" | "#" | "$" | "%" | "&" | "'" | "*" | "+" | "-" | "/" 
           | ":" | "\;" | "<" | "=" | ">" | "?" | "@"
           | "[" | "\\" | "]" | "^" | "_" | "{" | "}" | "|" | "~"

<symbol> ::= <word_symbol> | <space> | <printable> | "," | "\t" | "\n" | "(" | ")"

<word> ::= <word_char> | <word_char> <word>

<char_value> ::= "'" <symbol> "'"

<bool> ::= "faux" | "fausse" | "vrai" | "vraie"
```

As the language is heavily based on the **French language**, it has shaped many of our syntax decisions :

- We made it mandatory to put spaces where needed in case of punctiation, as it is a [french grammar rule](https://formations.mer.gouv.fr/sites/default/files/2023-11/Espacement%20avant%20et%20apr%C3%A8s%20les%20signes%20de%20ponctuation%20et%20les%20symboles.pdf). This works for (':', '.', '«', '»', ',').
- We decided to replace all operations symbols by their literal French equivalent as we wanted this language to use **as many french words as possible** in order to represent **France**. Therefore, operations such as `+` or `*` are being replaced by `plus` and `multiplié par`. This forces to have at least one space before and after such operations
as they are now depicted as **words**.
- As it can become easily overwhelming to type out every single operation using its own word representation, we created alternatives to some operations to make them
shorter. For example, the XOR `^` operation can either be typed out as `exclusif ou` or `xor`. The multiply `*` operation can also either be `multiplié par` or `fois`.
- We forced every file of our language to begin with `Bonjour,` (`Hello` in english) in order to fit with the French Culture as french citizens are widely known for their politeness. For the same reasons, `while` and `if` structures ends by `Merci.` (`Thank you`in english) and the main function ends with `Merci d'avance, Cordialement, <Name>\n<FamilyName>` (for `Thank you in advance, Best regards, <Name>\n<FamilyName>`) as this function is where the program stops.
- Words used to describe instructions such as `J'invoque` (`Invoke` in english) or `Affiche` (`Display` in english) were what we thought was the best way to directly translate such common instructions in **french**.
- As we wanted users to have a unique experience while using the language, instructions directly made by users are conjugated in the first person in order to simulate a conversation. Other instructions executed directly by the machine such as displaying are in imperative form in the second person.
- Every single instructions ends with a `.` as every single sentence in **french** ends the same way.
- `while` and `if` structures do not exactly share the same syntax in order to differentiate them properly : `if` takes a `,` at the end of the condition whereas `while` doesn't.
- Comparison are in the feminine form (`supérieure`, `égale`) since the French word `variable` is feminine.

## Language logic

### **Header**

A file in `Franc C` always starts with: "Bonjour," followed by an empty line.

Politeness is very important, and we wanted `Franc C` to express a proper and classic language, not a crappy street language.
We promise you will learn the "bien parlé" by using `Franc C`

### **Function Declaration**

In order to declare a function, you must specify:

#### The name of the function

```
J'aimerais définir le bloc répondant au nom de <function_name>,
```

where <function_name> is the name of the function


#### The return type of the function


```
de type de retour entier naturel,
```

for the function to return an integer.

```
de type de retour booléen,
```

for the function to return a boolean.

```
de type de retour nul,
```

if the function does not return anything. (void function)


#### The parameters of the function

A parameter, in Franc C, is defined the same way as other programming languages : Those are variables that must be passed when the function is invoked for it to use them.

```
necéssitant comme entrée :
    - <variable_name1>, de type <type>
    - <variable_name2>, de type <type>
    ...
;
```

You can include as many parameter as you want as long as they **do not share** the same name.

- `<variable_name1>` and `<variable_name2>` are the name of the variables which are both different.
- `<type>` is either `booléen` if the parameter is a `boolean` or `entier naturel` if it is an `int`.

Parameters are obviously optional. If the function does not take any parameters, you must specify :

```
nécessitant comme entrée : ;
```

#### Variables

Variables created and used inside a function, in Franc C, are defined in the function definition. 
Since Franc C is a very verbose language and uses a lot of words, creating variables at the top of the function makes it a very good way to clearly see them.

Such variables are being declared the following way :

```
contenant les variables :
    - <variable_name1>, de type <type>, valant <value>
    - <variable_name2>, de type <type>, valant <value>
;
```

Just like **parameters**, **variables** must not share the same name.
A **parameter** and a **variable** can not share the same name either.

- `<variable_name1>` and `<variable_name2>` are the name of the variables which are both different.
- `<type>` is either `booléen` if the variable is a `boolean` or `entier naturel` if it is an `int`.
- `<value>` is either a number or a boolean expression `vrai` `vraie` `faux` or `fausse`. It can also be a character value like `\n` (which will be 10).

This **forces** every single created variable to have a default value.

If the function does not use any variable, you must specify :

```
contenant les variables : ;
```

### **Function Body**

A function declaration ends with

```
représenté par le code <logical_connector>.
```

- `<logical_connector>` is either `ci-après`, `suivant`, or `ci-dessous`. 

What must follow this declaration is the **body of the function**, which is what **will be executed** when the function is **invoked**.

In Franc C, what can be executed inside a function is being refered as an `instruction`.

Those are the available instructions that you can execute inside a function :

#### Assignement

You can, at any time, change the value of a variable the following way :

```
J'aimerais que <variable_name> prenne la valeur <computables>.
```

or 

```
<variable_name> prends la valeur <computables>.
```

- `<variable_name>` represents the name of an existing well-defined variable of the function.
- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)

#### If

Execute a block of code only if a specific condition was met. It can be defined the following way :

```
Si <computables>, exécute le texte :
    <more_instructions>
Merci.
```

- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)
- `<more_instructions>` represents all the instructions that will be executed **ONLY** if the **condition** was **met**.
- `Merci.` represents the end of the condition.

You can also execute a block of code if the condition wasn't met the following way :

```
Si <computables>, exécute le texte :
    <more_instructions>
; sinon, exécute le texte :
    <more_instructions_2>
Merci.
```

- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)
- `<more_instructions>` represents all the instructions that will be executed **ONLY** if the **condition** was **met**.
- `<more_instructions_2>` represents all the instructions that will be executed **ONLY** if the **condition** was **not met**.
- `Merci.` represents the end of the condition.


#### Invoke

Invoke another function inside a function, you can also store its result in a well-defined function variable.

```
J'invoque le bloc <function_name>.
```

- `<function_name>` is the name of an **existing defined function**.

If the function that is being invoked takes parameters, they **must** be specified the following way :

```
J'invoque le bloc <function_name>, avec les paramètres <computables>, <computables>, <computables>.
```

- `<function_name>` is the name of an **existing defined function**.
- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)

You **must** not give to a function more parameters than it takes.

In order to store the result of a function, while still giving parameters :

```
J'invoque le bloc <function_name>, et j'assigne la valeur de retour à la variable <variable_name>, avec les paramètres <computables>, <computables>, <computables>.
```

- `<function_name>` is the name of an **existing defined function**.
- `<variable_name>` represents the name of an existing well-defined variable of the function.
- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)

However, if you do not want to give any parameter :

```
J'invoque le bloc <function_name>, et j'assigne la valeur de retour à la variable <variable_name>.
```

- `<function_name>` is the name of an **existing defined function**.
- `<variable_name>` represents the name of an existing well-defined variable of the function

#### Loop

The only type of loop that is currently implemented in `Franc C` are the `while` loops.

A loop allows to execute a block of code until a condition cannot be met anymore.

```
Tant que <computables> exécute le code ci-après :
    <more_instructions>
Merci.
```

- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)
- `<more_instructions>` represents all the instructions that will be executed **ONLY** if the **condition** was **met**.
- `Merci.` represents the end of the loop.

#### Return

During the execution of the function, you can return at any time a **value**.
Returning a value will cause the function execution to **stop**.

The only condition to return a value is that the function must not be of type "nul".

```
Enfin, renvoie <computables>.
```

- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)

If the function does not return anything (`nul` function), you can still stop the execution at any time.

```
Enfin, sors du bloc.
```

This works only if the function is a `nul` function.

#### Show statements

This instruction is used to display either a text, or the result of a computation in the screen.

To display a computation : 

```
Affiche <computables>.
```

- `<computables>` represents an expression composed of values with operators. (*Check the `<condition>` defintion on the BNF)

This will display **the character** corresponding to the result on the screen.
(E.g): `Affiche 10.` will display `\n`.

However, if you want to display a text : 

```
Affiche « Meow ».
```

This will display the text `Meow` on the screen.

### **End of Function**

You must **always** end your **Function Body** with a `Merci.`.

### **Special case of 'Main' Function**

The **main function** is where the program starts. Therefore, its defintion must be clearly different from the **other functions**.

Such functions are being defined the following way :

```
Bonjour,

En sachant que les variables principales sont :
    <variables>
; pourrais-tu s'il te plaît commencer la lecture ici ?
    <instructions>
Merci d'avance,
Cordialement,
<family_name>
<name>
```

- `<variables>` is an optional field, and represents the variables of the function. They are declared the same way as a normal function.
- `<instructions>` represents all the instructions that will be executed.
- `Merci d'avance, Cordialement, <family_name> <name>.` represents the end of the main function
- `<family_name>` represents the developer's last name, and must always end with a newline character ('\n').
- `<name>` represents the developer's first name, and must also end with a newline character ('\n').

A **main function** does not take any parameter. Therefore, no parameter definition must be done.
The value being **returned** in the **main function** represent the exit status of the program. If no value was being **returned**, the program exists by default with a status code of `0`.