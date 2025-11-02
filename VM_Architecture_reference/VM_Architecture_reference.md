# VM Architecture 

When defining an assembly language for the Franc C binary, we focused on the ease of development of the compiler. We just had one requirement that allowed an easy development of the virtual machine: our assembly shall be [stack-based](https://en.wikipedia.org/wiki/Stack-oriented_programming), drawing inspiration from the [Java Virtual Machine (JVM)](https://en.wikipedia.org/wiki/Java_virtual_machine).

### Stack-Based vs Register-Based

| Aspect            | Stack-Based (fcvm)                                          | Register-Based (e.g., Lua VM) |
|-------------------|-------------------------------------------------------------|-------------------------------|
| **Storage**       | Operand stack (LIFO)                                        | Virtual registers             |
| **Instructions**  | Compact, implicit operands, prone to errors                 | Explicit operand addressing   |
| **Complexity**    | Simple to implement                                         | More complex logic            |
| **Bytecode Size** | Bigger overall (smaller instructions but way more quantiry) | Smaller overall               |

We chose a stack-based approach for the following reasons:

1. **Simpler bytecode generation**: The compiler does not have to deal with registers, knowing it does not have the capacity to remember data while processing multiple operations.
2. **Monotyped language**: The fact that the Franc C is an integer only language allows for fixed-size parameter encoding. One of the main advantages of the register-based approach is to allow for type encoding.

## Stack

The stack is implemented as a contiguous array of bytes with the following characteristics:

- **Data type**: Array of bytes
- **Element size**: 8 bytes per element (64-bit signed integers)
- **Alignment**: All operations push/pop exactly 8 bytes
- **Stack size**: Always a multiple of 8 bytes

#### Stack Management

To optimize performance, and perform function calls, the VM maintains two contextual data:

- **Stack Pointer (SP)**: Points to the start of the current stack local context. Modified by the instructions call and ret
- **Stack Counter**: Tracks the number of elements, avoiding recalculation after each operation

### Initialization

By default, the stack is initialized with 8 bytes representing the return value of the program.
The default value is implementation-defined.

### Basic Operations

| Operation | Description | Stack Effect |
|-----------|-------------|--------------|
| **PUSH**  | Push 8 bytes onto the stack | SP unchanged, Counter += 1 |
| **POP**   | Remove 8 bytes from the stack | SP unchanged, Counter -= 1 |

## CallStack 

The **callstack** manages function calls and returns, enabling the VM to:
- Navigate between functions
- Restore execution context after function returns
- Maintain function-local state
- Detect program termination

### Memory Layout

The callstack is implemented as a contiguous array of frame records:\
By default, the callstack is initialized as an **empty array**.

- **Data type**: Array of tuples `[(PC, SP)]`
  - **PC** (Program Counter): Return address (next instruction after CALL)
  - **SP** (Stack Pointer): Stack state at call time

| Frame | PC | SP | Description                   |
|:-----:|:--:|:--:|:-----------------------------:|
| 0     | 0  | 0  | Entry point                   |
| 1     | 12 | 16 | First function call           |
| 2     | 57 | 24 | Current function locale start |

### Function call mechanism

When executing `call <address>`:

1. **Save current context**: Push `(PC + 1, SP)` onto the call stack
   - `PC + 1`: Address of the instruction following CALL
   - `SP`: Current stack pointer (preserves caller's stack)
2. **Jump to function**: Set `PC = <address>`

When executing `Ret`:

1. **Pop frame**: Retrieve `(saved_PC, saved_SP)` from call stack
2. **Restore context**: 
   - Set `PC = saved_PC` (return to caller)
   - Set `SP = saved_SP` (restore stack state)
3. **Check termination**: If call stack is empty after pop, **terminate program**

## Zero flag

The **Zero Flag** is a single-bit register used for conditional branching and control flow decisions.\
It stores the result of comparison and test operations, \
enabling the implementation of `if` and `while`.

- **Data type**: `unsigned char`
- **Default value**: `1`

The Zero Flag follows this logic:

| Condition | Zero Flag Value |
|-----------|-----------------|
| **!= 0**  | `1` (true)      |
| **== 0**  | `0` (false)     |

## End cases

The VM can terminate execution in two ways:
1. **Normal termination**: Program completes successfully
2. **Error termination**: An error condition is encountered

### Successful Execution

The program terminates normally when:
- A `Ret` instruction is executed from the main function
- The call stack becomes empty after the return

### Error Termination

When an error occurs, the VM immediately halts execution and returns **exit code 84**.

#### 1. File Format Errors

| Error                    | Condition                                    | When Detected     |
|--------------------------|----------------------------------------------|-------------------|
| **Invalid Magic Number** | Bytecode header doesn't match expected value | VM initialization |
| **Invalid Entry Point**  | Entry address out of bounds                  | Loading phase     |

##### 2. Arithmetic Errors

| Error                | Condition              | Example  |
|----------------------|------------------------|----------|
| **Division by Zero** | `div` with divisor = 0 | `10 / 0` |
| **Modulo by Zero**   | `mod` with divisor = 0 | `10 % 0` |

##### 3. Stack Errors

| Error               | Condition                               | Cause                                |
|---------------------|-----------------------------------------|--------------------------------------|
| **Stack Overflow**  | Operand stack exceeds maximum capacity  | Too many PUSH operations without POP |
| **Stack Underflow** | Attempt to POP from empty operand stack | More POP than PUSH operations        |

##### 4. Call Stack Errors

| Error                   | Condition                        | Cause                                                     |
|-------------------------|----------------------------------|-----------------------------------------------------------|
| **Call Stack Overflow** | Call stack exceeds maximum depth | Too many nested function calls (e.g., infinite recursion) |
|                         |                                  |                                                           |

---

**Version** : 1.1  
**Last update** : Novembre 2025  
**Author** : Acacademie Franc C'aise
