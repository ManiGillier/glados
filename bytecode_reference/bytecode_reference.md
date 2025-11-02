
The bytecode starts with a magic number, followed by an address describing the placement of the PC at the start of the program, followed by the program itself.

# Formal syntax (BNF)

```bnf
<bytecode> ::= <magic_number> <adress> <operation_list>

<magic_number> ::= "E\fE\f" ; 0x45 0xc 0x45 0xc

<adress> ::= <byte> <byte> <byte> <byte> <byte> <byte> <byte> <byte>

<operation_list> ::= <operation> | <operation>  <operation_list>

<operation> ::= <not>
              | <lnot>
              | <neg>
              | <and>
              | <or>
              | <xor>
              | <shl>
              | <shr>
              | <land>
              | <lor>
              | <add>
              | <sub>
              | <mult>
              | <div>
              | <mod>
              | <gt>
              | <ge>
              | <lt>
              | <le>
              | <eq>
              | <diff>
              | <updz>
              | <push_stack>
              | <pop_stack>
              | <pop>
              | <call>
              | <ret>
              | <jmp>
              | <zjmp>
              | <aff>
              | <affs>
              | <push_value>
              | <push_label>


<not> ::= "\003"

<lnot> ::= "\004"

<neg> ::= "\005"

<and> ::= "\006"

<or> ::= "\a"

<land> ::= "\b"

<lor> ::= "\t"

<xor> ::= "\n"

<shl> ::= "\v"

<shr> ::= "\f"

<add> ::= "\r"

<sub> ::= "\016"

<mult> ::= "\017"

<div> ::= "\020"

<mod> ::= "\021"

<gt> ::= "\022"

<ge> ::= "\023"

<lt> ::= "\024"

<le> ::= "\025"

<eq> ::= "\026"

<diff> ::= "\027"

<updz> ::= "\030"

<push_stack> ::= "\035" <arguments>

<pop_stack> ::= "\036" <arguments>

<pop> ::= "\037"

<call> ::= """

<ret> ::= "#"

<jmp> ::= "$"

<zjmp> ::= "%"

<aff> ::= "&"

<affs> ::= "'" <arguments> <string>

<push_value> ::= "Y" <arguments>

<push_label> ::= "[" <arguments>

<arguments> ::= <byte> <byte> <byte> <byte> <byte> <byte> <byte> <byte>

<string> ::= <byte> | <byte> <string>

<byte > =  "\0" .. "ÿ"

```

# Instructions

Since the virtual machine is stack-based, every instruction representing an operation will pop it's operands, and push the result to the stack.

| mnemonic | description | bnf object |
|:---------|-------------|-----------:|
| not | Not, invert the bits of the operand | not |
| lnot | Logical not, invert the boolean interpretation of the operand | lnot |
| neg | Negate, switch the sign of the operand | neg |
| and | And, performs a binary AND operation between two operands | and |
| or | Or, performs a binary OR operation between two operands | or |
| xor | Exclusive or, performs a binary XOR operation between two operands | xor |
| shl | Left bitshift, shifts the bits  of the operand to the left, appending zeroes | shl |
| shr | Right bitshift, shifts the bits of the operand to the right, appending zeroes | shr |
| land | Logical and, boolean interpretation of the logical AND on two operands | land |
| lor | Logical or, boolean interpretation of the logical OR on two operands | lor |
| add | Addition, adds the value of two operands | add |
| sub | Substraction, subtract the value of two operands | sub |
| mult | Multiplication, multiplies the value of two operands | mult |
| div | Division, return the dividend of the euclidian division of operand 1 by operand 2 | div |
| mod | Modulo, return the rest of the euclidian division of operand 1 by operand 2 | mod |
| gt | Greater than, compares the two operands and return a result for boolean interpretation | gt |
| ge | Greater than or equals to, compares the two operands and return a result for boolean interpretation | ge |
| lt | Less than, compares the two operands and return a result for boolean interpretation | lt |
| le | Less than or equals to, compares the two operands and return a result for boolean interpretation | le |
| eq | Equals, compares the two operands and return a result for boolean interpretation | eq |
| neq | Different from, compares the two operands and return a result for boolean interpretation | diff |
| updz | Update zero flag, pops the value from the stack and set it as the new zero flag | updz |
| push | Push value, push a 64 bits value to the stack | push_value |
| push | Push relative address, push a 64 bits relative address to the stack, corresponding generally to a label | push_label |
| push | Push from stack pointer relative address, push to the stack the 8 bytes found at the stack pointer + the address given as operand | push_stack |
| pop | Pop empty, pop 8 bytes from the stack | pop |
| pop | Pop to stack pointer relative address, pop 8 bytes from the stack, and write them to the stack pointer + the address given as operand | pop_stack |
| call | Call, op 8 bytes from the stack, register the new stack pointer, push the PC and stack pointer to the callstack, and jump to the value of the 8 bytes popped from the stack | call |
| ret | Return, reset the stack to the stack pointer, pop the callstack and jump to the address from the callstack pop | ret |
| jmp | Jump, pop an address from the stack, and set the PC to it | jmp |
| zjmp | Zero jump, pop an address from the stack, and if the zero flag is set, set the PC to it | zjmp |
| aff | Show, pop 8 bytes from the stack, apply a modulo 256 to the result, and write a single ascii character corresponding to the result | aff |
| affs | Show string, the first operand is a 64 bits integer corresponding to the number of caracters, that we will call n. The next n bytes are the ascii values of the characters that will be wrote | affs |
