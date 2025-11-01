# Language reference

## Language inspirations

[ToDo]

## Language motives

[ToDo]

## Language Formal Syntax (BNF)

```
<header> ::= "Bonjour," <spaces>

<main> ::= "En" <spaces> "sachant" <spaces> "que" <spaces> "les" <spaces> "variables" <spaces> "principales" <spaces> "sont" <spaces> ":" <spaces> [<variable_list>]
 ";" <spaces> "pourrais-tu" <spaces> "s'il" <spaces> "te" <spaces> "plaît" <spaces> "commencer" <spaces> "la" <spaces> "lecture" <spaces> "ici" <spaces> "?" [<spaces>] <block> [<spaces>] "Merci d'avance," <spaces> "Cordialement," <spaces> <name> <name>

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

<function_definition> ::= "J’aimerais" <spaces> "définir" <spaces> "le" <spaces> "bloc" <spaces> "répondant" <spaces> "au" <spaces> "nom" <spaces> "de" <spaces> <word> "," <spaces> "de" <spaces> "type" <spaces> "de" <spaces> "retour" <spaces> <function_type> "," <spaces> "nécessitant" <spaces> "comme" <spaces> "entrée" <spaces> ":" <spaces> [<parameter_list>] ";" <spaces> "contenant" <spaces> "les" <spaces> "variables" <spaces> ":" <spaces> [<variable_list>] ";" <spaces> "représenté" <spaces> "par" <spaces> "le" <spaces> "code" <spaces> ("suivant" | "ci-après" | "ci-dessous") "." [<spaces>] <block> <spaces> "Merci."

<text> ::= <symbol> [<text>]

<quoted_value> ::= "« " <text> " »"

<block> ::= <statement_list>

<statement_list> ::= <statement> [[<spaces>] <statement_list> [<spaces]]

<statement> ::= <condition_statement> | <return_statement> | <loop_statement> | <display_statement> | <invoke_statement> | <assignment_statement>

<return_statement> ::= "Enfin," <spaces> "renvoie" <spaces> <condition> "." | "Enfin," <spaces> "sors" <spaces> "du" <spaces> "bloc."

<condition_definition> ::= "Si" <spaces> <condition> "," <spaces> "exécute" <spaces> "le" <spaces> "texte" <spaces> ":"

<condition_statement> ::= <condition_definition> <space> <block> "Merci."
    | <condition_definition> <space> <block> ";" <space> "sinon" <space> "exécute" <space> "le" <space> "texte" <space> ":" <block> "Merci."

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
           | ":" | ";" | "<" | "=" | ">" | "?" | "@" 
           | "[" | "\\" | "]" | "^" | "_" | "{" | "}" | "|" | "~"

<symbol> ::= <word_symbol> | <space> | <printable> | "," | "\t" | "\n" | "(" | ")"

<word> ::= <word_char> | <word_char> <word>

<char_value> ::= "'" <symbol> "'"

<bool> ::= "faux" | "fausse" | "vrai" | "vraie"
```

As the language is heavily based on the **French language**, it has shaped many of our syntax decisions :

- We made it mandatory to put a space before and after a puncutuation sign as it is a [french grammar rule](https://formations.mer.gouv.fr/sites/default/files/2023-11/Espacement%20avant%20et%20apr%C3%A8s%20les%20signes%20de%20ponctuation%20et%20les%20symboles.pdf). This works for (':', '.', '«', '»').
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
