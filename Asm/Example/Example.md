# Example of the function if_while in the asm of the Franc

func_main:  
.start:  
&nbsp;&nbsp;&nbsp;&nbsp;push 10  
loop:  
&nbsp;&nbsp;&nbsp;&nbsp;push 0  
&nbsp;&nbsp;&nbsp;&nbsp;push @0  
&nbsp;&nbsp;&nbsp;&nbsp;diff  
&nbsp;&nbsp;&nbsp;&nbsp;updz  
&nbsp;&nbsp;&nbsp;&nbsp;push %endLoop  
&nbsp;&nbsp;&nbsp;&nbsp;zjmp  
&nbsp;&nbsp;&nbsp;&nbsp;push 41  
&nbsp;&nbsp;&nbsp;&nbsp;aff  
&nbsp;&nbsp;&nbsp;&nbsp;push 1  
&nbsp;&nbsp;&nbsp;&nbsp;sub  
&nbsp;&nbsp;&nbsp;&nbsp;push %loop  
&nbsp;&nbsp;&nbsp;&nbsp;jmp  
endLoop:  
&nbsp;&nbsp;&nbsp;&nbsp;ret  