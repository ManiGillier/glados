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

See [the parsing reference](#parsing-reference) for more information.

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
