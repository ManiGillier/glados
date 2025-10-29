# Explanation of the Asm of the Franc-C

The Asm of the Franc-C is a stack-based assembly.

In Every file, a ".start" label need to be there

The Instructions are always put after a label and must should a tab (4 spaces) before them.

## List of instruction and their description

### Label

label : Name of the label

### Unary Operation

pop do the math and push

not: Inverse the bit(s).  
lnot: Logical not, inverse the value of a boolean.  
neg: Negate the value.

### Binary Operation

pop the 2 on top of stack do the math and push the result

and : Copies a bits if it exist in both operands (value)  
nor: Copies a bits if it exist in either operands (value)  
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
push %: Push the adress of the label given as an arguments  
push @: -- Push the value from the position as an arguments  

### Pop

pop @: Pop the element at the position given as an arguments  
pop: Pop the stack  

### Function

call: Call the top stack function  
ret: Resume previous function back or end the programm  

### Jumps

jmp: Go to the top stack adress  
zjmp: If Zflag equal 0 go to the top stack adreselse continue  

### Display

aff: Display top stack char and pop it  
affs: Display top stack string given as an argument   

<!-- zflag : il retient en mémoire le Z flags si true ou false qui est utilisé pour zjmp -->
