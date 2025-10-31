# Explanation of the Asm of the Franc-C

The Asm of the Franc-C is a stack-based assembly.

In Every file, a ".start" label need to be there

The Instructions are always put after a label and must should a tab (4 spaces) before them.

## List of instruction and their description

### Label

|   Opération   |   Description     |
|   :--------   |   ----------:     |
| Label:        |  Name of the label|

### Unary Operation

#### Pop the first element on top of the stack, do the operation and push the result

|   Opération   |   Description     |
| :------------ | --------------:   |
| not:          | Inverse the bit(s).|
| lnot:         | Logical not, inverse the value of a boolean.|
| neg:          | Negate the value. |

### Binary Operation

#### Pop the 2 firsts elements on top of the stack, do the operation and push the result


|   Opération   |   Description     |
| :------------ | --------------:   |
| and:          | Copies the bits if it exist in the 2 elements on top of the stack |
| nor:          | Copies the bits if it exist in one the 2 elements on top of the stack |
| land:         | logical and |
| lor:          | logical or |
| xor:          | Copies a bit if it exist in only in one the 2 elements on top of the stack |
| shl:          | Move the bits to the left one time (0101 -> 1010)|
| shr:          | Move the bits to the right one time (1010 -> 0101)|
| add:          | Addition |
| sub:          | Subtraction |
| mult:         | Multiplication |
| div:          | Division |
| mod:          | Modulo |
| gt:           | Greater than |
| ge:           | Greater or equal |
| lt:           | Less than |
| le:           | Less or equal |
| eq:           | Equal |
| diff:         | Different |

### Push And Pop

<!-- #### Push : Add an element on the top of the stack, Pop: delete an element on the top of the stack -->

|   Opération   |   Description     |
| :------------ | --------------:   |
| push:         | Push the value in the stack |
| push %:       | Push the adress of the label given as an arguments |
| push @:       | Push the value from the position as an arguments |
| pop @:        | Pop the element at the position given as an arguments |
| pop:          | Pop the stack |

### Function

|   Opération   |   Description     |
| :------------ | --------------:   |
| updz:         | Update the Zflags (true or false) this is used before Zjmp |
| call:         | Call the top stack function |
| ret:          | Resume previous function back or end the programm |
| jmp:          | Go to the top stack adress |
| zjmp:         | If Zflag equal 0 go to the top stack adreselse continue |

### Display

|   Opération   |   Description     |
| :------------ | --------------:   |
| aff:          | Display top stack char and pop it |
| affs:         | Display top stack string given as an argument |
