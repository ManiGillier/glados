# Spec of the Bytecode of the Franc

The Bytecode start with the magic number which is (69,12,69,12).

After that, it takes 8 bytes for the start adress.

then the instruction which take 1 byte, 8 bytes for an argument if needed, and then a byte of 0 to specify the end of the instruction

|     Opération et format     |     Mnémonique / Syntaxe     |     Arguments     |     Description     |
|     :------------------     |     :------------------:     |     :-------:     |     ----------:     |
|     69,12,69,12             |    Magic Number              |   \               |   Magic Number      |
|     1                       |    DataInt                   |   V               |   create a variable with a type Int |
|     2                       |    DataString                |   V               |   create a variable with a type String
|     3                       |    BinNot                    |   \               |   not    |
|     4                       |    BoolNot                   |   \               |   lnot   |
|     5                       |    Negate                    |   \               |   negate |
|     6                       |    BinAnd                    |   \               |   and    |
|     7                       |    BinOr                     |   \               |   or     |
|     8                       |    BoolAnd                   |   \               |   land   |
|     9                       |    BoolOr                    |   \               |   lor    |
|     10                      |    Xor                       |   \               |   xor    |
|     11                      |    BitShiftLeft (shl)        |   \               |   bit shift left    |
|     12                      |    BitShiftRight (shr)       |   \               |   bit shift right    |
|     13                      |    Add                       |   \               |   addition    |
|     14                      |    Sub                       |   \               |   subtraction    |
|     15                      |    Mult                      |   \               |   multiplication   |
|     16                      |    Div                       |   \               |   division    |
|     17                      |    Mod                       |   \               |   modulo    |
|     18                      |    Gt                        |   \               |   greater     |
|     19                      |    Ge                        |   \               |   greater or equal     |
|     20                      |    Lt                        |   \               |   less    |
|     21                      |    Le                        |   \               |   less or equal   |
|     22                      |    Eq                        |   \               |   equal     |
|     23                      |    Diff                      |   \               |   different   |
|     24                      |    UpdateZFlag               |   \               |   pop the stack, if zero set z flag to 1 else 0   |
|     29                      |    PushFromStackPtrRel       |   V               |   push the value stored   |
|     30                      |    PopToStackPtrRel          |   V               |   pop and set to the address   |
|     31                      |    PopEmpty                  |   \               |   pop    |
|     33                      |    Dupl                      |   \               |   duplicate the last stack entry   |
|     34                      |    Call                      |   \               |   Subroutine call   |
|     35                      |    Ret                       |   \               |   return    |
|     36                      |    Jmp                       |   \               |   Jump to address    |
|     37                      |    Zjmp                      |   \               |   Jumpt to adress if value equal 0 eles continue |
|     38                      |    Aff                       |   \               |   aff    |
|     39                      |    Label                     |   \               |   label  |
|     89                      |    PushValue                 |   V               |   push an Int   |
|     90                      |    PushGlobAddr              |   V               |   push an adress   |
|     91                      |    PushRelAddr | PushLabel   |   \               |   push the label |
|     96                      |    WriteToStackPtrRel        |   V               |   Write Int to stack ptr + Addr     |

