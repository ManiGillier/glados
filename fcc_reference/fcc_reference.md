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

