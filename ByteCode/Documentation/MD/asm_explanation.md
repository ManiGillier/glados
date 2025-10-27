# Explanation of the Asm of the Franc

The Asm of the Franc is a stack-oriented/stack-based assembly.

In Every file, a ".start" label need to be there

The labels always end with ':'

The Instructions are always put after a label and every instructions must have a tab (4 spaces) before them.

## List of instruction and their description

label : Name of the function + ':'

not: inverse the bit(s).
lnot: logical not, "negates" the value of a boolean.
neg: negate the value.
and: if bit a = 1 and bit b = 1 return 1 else 0
nor: if bit a = 0 and bit b = 0 return 0 else 1
land: logical and, <!-- if both of the value are true then return true else false -->
lor: logical or,
xor: if bit a is different from bit b return 1 else 0
shl: move the bits to the left (001 -> 100)
shr: move the bits to the right (100 -> 001)
add: addition + pop the last push and add to the second
sub: subtraction
mult: multiplication
div: division
mod: modulo
gt: greater than
ge: greater or equal
lt: less than
le: less or equal
eq: equal
diff: different
updz: Update the Zflags (true or false) this is used before Zjmp
push: push the value in the stack
push []: push the relative adress given as an arguments
push %: push the label given as an arguments
push @: -- push the value from the position given of the stack
        push


pop @: pop given as an arguments
pop: pop the stack
call: call the function given previously by push %
ret: return
jmp: go to the label given previously by push %
zjmp: if value equal 0 go to the label given previously by push % else continue
aff: display the value
affs: 

zflag : il retient en mémoire le Z flags si true ou false qui est utilisé pour zjmp