The Franc C Compiler (FCC) is a toolchain that allows the compilation of one or multiple Franc C Reference code (.fr) files into a single bytecode executable by the FCVM program.

# Parameters list and long descriptions

`fcc FILESNAME [-o|--output FILENAME] [-n|--no-larousse] [-d|--debug]`

## FILESNAME

The name of the input files.
They need to be valid .fr source files.

## --output FILENAME

The name of the output bytecode file.
Only considered without the --debug flag.

Without the presence of this flag, the default output file is `a.fcp`.

## --no-larousse

By default, the FCC program compiles with the Larousse sources included.
See the [larousse](#larousse) section.

This flag allows compilation without any files from the Larousse library.

## --debug

This flags allows a debug output.
Instead of writing the bytecode to a file, a debug view of the assembly is wrote to the standard output (/dev/stdout on most GNU/linux machines).

# Larousse

The Larousse is the standard library who accompanies the FCC program.
If the Larousse is to be included, the `fcc` program will search a folder named `larousse`, and then list in all subdirectories of level-1 the `.fr` source files.
Those found source files will be added to the input list, and compiled.

# Functioning

The FCC program works with different steps.

## Getting inputs

The inputs are retrived via the Larousse library and the user-provided files.

## Lexing and parsing

Each file is lexed into a list of token, then parsed into an Abstract Syntax Tree (AST).

See [the parsing reference](#lexer-parsing-reference) for more information.

This step may fail. Each file being converted one after the other, if one fails, the remaining ones are not even considered and an error is returned.

## Combination

Each AST representing each files given for compilation is then combined.

In this step, the presence of a single principal function is verified, and if no or multiple are found, an error is returned.

The result is a CAST (Combined Abstract Syntax Tree)

## Compilation

The compilation step is where the CAST is converted to a Context datastructure, linked with an Assembly datastructure. It is not yet bytecode, just a structure representing the final output.

The context structure is important for the next step.

This step is really linear, there is no acknowledgement of the rest of the program when compiling a subpart.

## Verifications

This step ensures some basic verifications.

It takes the context from the previous step, and analyses it to find any flaws.

For example, we check here if a function is invoked whilst it's reference is non-existant.

## Output

This step is the final one.

If the `--debug` flag is given, it will take the structured assembly and write it down just as it is stored.

Elsewise, it is converted to bytecode in really two small steps.
The first one is to convert labels to relative positions.
The second one is to convert everything to it's bytecode relation.

Finaly, the resulted bytecode is written to the designated output file.

## Justifications

Regarding the lexing and parsing part, we decided so separate those to allow for easier syntaxic sugar implementation and code readability.

The combination part was added to allow for multiple input files to be grouped together before the compilation process. It is easier to do it like this than to try and combine multiple outputed bytecodes together, like the `ld` program does when compiling a C program.

The compilation is linear, and therefore, we had to separate the verification process from this step, to allow for a really easy-to-read code.
Having a linear compilation reduces the capacity of complex program logic, but since the Franc C is a really simple imperative language, it poses no problems to do it this way.
We simply store some context in a datastructure for the verification step to look in a global point of view, instead of the linearly reduced point of view of the compilation.

Finaly, we send the assembly to out output step, that is in charge of converting it to the final bytecode, or to write it as a debug output.

# Lexer & Parsing reference

We have chosen Haskell to implement the lexing and parsing of the language, as functional languages like Haskell make it particularly easy to express, abstract, and combine parsers. This allows the Franc C to be very verbose, which was definitely needed.

As we wanted to speed things up and release a first version as quickly as possible, we decided to use a pre-existing parsing library `Megaparsec`. The library offers fast parsing performance, is an improved successor of `Parsec`, and provides high-quality error messages that greatly simplify debugging and development.

The `Lexer` and `Parser` both refers to two different parts:

- The `Lexer`, which uses `Megaparsec` reads the source code’s syntax, checks that it follows the correct grammar, then converts the text into a list of tokens that the parser can later use.
For example, the code `Si x est égale à 0, exécute le texte` would be transformed into the list as `[If, Symbol "x", Operation Equals, Number 0, Then]`
- The `Parser`, on the other hand, takes this list of tokens to transform it into an **Abstract Syntax Tree** (AST). It uses Haskell's recursive principles to build that tree so that the compiler can later use it to generate the final executable library.

The `Parser` is only executed if the `Lexer` did not fail to lex the targetted source code.

## Safety measures

The safety of the lexing process is ensured by `Megaparsec`, which provides robust error handling and syntax checking.
During the lexing part, Megaparsec ensures the input strictly follows the defined grammar. If the syntax is incorrect, the lexer fails gracefully by producing a clear and descriptive error message, preventing the program from continuing with an invalid input.
If the syntax is valid, the lexer successfully returns a well-structured list of tokens that can safely be passed to the parser.

Since the Lexer always produces a clean and valid list of tokens, the Parser does not include any additional safety checks on its input.
However, it makes sure that no more than **one** main function was defined.

## Error list

- Grammar Error : Triggered when Megaparsec fails to lex or parse the source code due to **invalid syntax**.
- Double Main Definition : Raised when more than one main function was defined in the program.

## Known caveats

- Lexing Error Printing : We are aware that Megaparsec does not always display clear or accurate error messages in some cases.
This issue is due to our current lexing implementation rather than Megaparsec itself, and should be fixed soon or later.
- Parsing Input : The parser currently does not validate its input and fully relies on the lexer to always produce correct and consistent tokens. While this works for now, it could lead to potential issues in the future.

# Compilation reference

We are here referring to compilation as the compilation and the verification step.
Thus, in this section, the compilation step will refer to both of these steps.

Given the simple nature of the logic of the Franc C language, we chose here to implement a simple compilation.

The compilation step do not use any external dependencies.

We simply store a context that is updated throughout the compilation process.
This context contains :

- A list of variables, with their name, size, and position relative to the stack pointer.
- A label counter, used to suffix labels with a number to distinguish them.
- A list of function context, representing each definitions.
- A list of function context, representing each invoke.

The function context contains :

- The name of the function.
- A boolean value, used to describe if this function is either returning something or of the void type ; or describes if this functions is either assigning a value when invoking or not.
- A parameter count, that indicates the number of parameters in this function.

The fact that the entire language is only integer-based facilitates the concept of variable storage and parameter types. No types appear in the compilation process, except the void type for function definitions and invoke.

## Function call parameters, return value and variables

When a function is called, it have parameters, a return value and some variables.

Here is a map of how they are stored in the stack:

```
┌─────────────────┐
│  Caller frame   │
├─────────────────┤
│  Parameters     │  ← PUSHREL/POPREL access
├─────────────────┤
│  Return Value   │  ← PUSHREL/POPREL access
├─────────────────┤  ← SP
│  Local vars     │  ← PUSHREL/POPREL access
├─────────────────┤
│  Temporaries    │  ← Stack top
└─────────────────┘
```

**Local variables**: Accessed via SP-relative offsets
- `PUSHREL 0`: First local
- `PUSHREL 8`: Second local (8-byte offset)
- `POPREL N`: Store to local at offset N

**Return value and paramers**: Accessed via SP-relative offsets
- `PUSHREL -8`: Return value
- `PUSHREL -16`: First parameter
- `PUSHREL -24`: Second parameter


## Safety measures

During the compilation step, we check for user errors :

- No main function is given.
- Multiple main functions are given.
- A function is defined with the name of an already defined function.
- A function defines a parameter, or a variable, with the name of an already existing, local to the function, parameter or variable.
- A function that is not referenced is invoked.
- A function that takes n parameters is invoked with more or less than n parameters.
- A return value is given to a function of type void.
- An empty return is given to a function of type non-void.
- An assignement of the return of a void-typed function is made.

## Intended undefined behaviours

### Integer over/underflows

We do not devine the result of an integer overflow, or an integer underflow.
Our integers are defined solely as signed integers on 64 bits.

The minimum integer is defined as the maximum integer negated.
In the C programming language, it is defined as being one less, but in our implementation of the negate sign "-", we chose for parsing and lexing simplicity to use the negate solely as an operation.
Take the example "-5", we will not register it as the -5 number, but as the number 5 on whom we apply the negate operation.
This explains the fact that our minimum integer is defined as the negated maximum integer.

The maximum integer is defined as 2^63 - 1, or 9'223'372'036'854'775'807.

### Known caveats

#### Lack of static analysis

The FCC compilation step do not implement any static analysis.

These are the direct cause of some -- sadly -- not implemented behavious:

- We cannot check for direct division by zero.
  For example: (10 divisé par 0) will not result in an error at compile-time.
- We cannot produce pre-computations.
  For example: (10 plus 10) will not result in the value 20 at compile-time,
  but in the computation of 10 plus 10 at run-time. It is highly inefficient.

# Readable assembly

When the `--debug` flag is passed, the output of the program is a readable assembly written to the standard output.

## Syntax of the readable assembly

There are two cases in the syntax :

- label, they are written in the left margin, like so: `label_name:`
- instructions, they are written tabulated with four spaces, like so:
  `    mnemonic [args]`

## List of instructions

| Operation                                | Parameter  |     Representation |
|:-----------------------------------------|------------|-------------------:|
| label                                    | name       |            `name:` |
| binary not                               |            |              `not` |
| binary and                               |            |              `and` |
| binary or                                |            |               `or` |
| logical not                              |            |             `lnot` |
| logical and                              |            |             `land` |
| logical or                               |            |              `lor` |
| exclusive or                             |            |              `xor` |
| left bitshift                            |            |              `shl` |
| right bitshift                           |            |              `shr` |
| addition                                 |            |              `add` |
| substraction                             |            |              `sub` |
| multiplication                           |            |             `mult` |
| division                                 |            |              `div` |
| modulo                                   |            |              `mod` |
| comparison greater than                  |            |               `gt` |
| comparison greater or equal to           |            |               `ge` |
| comparison less than                     |            |               `lt` |
| comparison less or equal to              |            |               `le` |
| comparison equals                        |            |               `eq` |
| comparison different to                  |            |              `neq` |
| update zero flag                         |            |             `updz` |
| push value                               | value      |       `push value` |
| push relative address                    | address    |   `push [address]` |
| push label relative address              | label-name | `push %label-name` |
| push from stack pointer relative address | address    |    `push @address` |
| pop to stack pointer relative address    | address    |     `pop @address` |
| pop                                      |            |              `pop` |
| invoke a function                        |            |             `call` |
| return                                   |            |              `ret` |
| jump to address                          |            |              `jmp` |
| jump to address if zero flag             |            |             `zjmp` |
| print character                          |            |              `aff` |
| print string                             | string     |    `affs "string"` |
