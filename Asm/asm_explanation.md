# Explanation of the Asm of the Franc

The Asm of the Franc is a stack-oriented/stack-based assembly.

In Every file, a ".start" label need to be there

The labels always end with ':'

The Instructions are always put after a label and must should a tab (4 spaces) before them.

## List of instruction and their description

### Label

label : Name of the function + ':'

### Unary Operation

not: Inverse the bit(s).  
lnot: Logical not, inverse the value of a boolean.  
neg: Negate the value.  

### Binary Operation

and : Copies a bit if it exist in both operands (value)  
nor: Copies a bit if it exist in either operands (value)  
land: Logical and, <!-- if both of the value are true then return true else false -->
land: If both value are True return True else return False  
lor: logical or,  
xor: Copies a bit if it exist in only one operands (value)  
shl: Move the bits to the left one time (0101 -> 1010)  
shr: Move the bits to the right one time (1010 -> 0101)  
add: Addition <!-- Pop the first (on top) element and add the value to the second element   -->
sub: Subtraction  
mult: Multiplication  
div: Division  
mod: Modulo  
gt: Greater than  
ge: Greater or equal  
lt: Less than  
le: Less or equal  
eq: Equal  
diff: Different  
updz: Update the Zflags (true or false) this is used before Zjmp  

### Push

push: Push the value in the stack  
push []: Push the relative adress given as an arguments  
push %: Push the label given as an arguments  
push @: -- Push the value from the position given of the stack  

### Pop

pop @: Pop given as an arguments  
pop: Pop the stack  

### Function

call: Call the function given previously by push %  
ret: Return  

### Jumps

jmp: Go to the label given previously by push %  
zjmp: If value equal 0 go to the label given previously by push % else continue  

### Display

aff: Display a char  
affs: Display a string  

<!-- zflag : il retient en mémoire le Z flags si true ou false qui est utilisé pour zjmp -->
