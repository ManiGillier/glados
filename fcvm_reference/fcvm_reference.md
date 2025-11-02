
# Input Descriptions

## Bytecode File Format

The fcvm executes Franc C bytecode files.

They have the following header structure:

```
┌─────────────────────────────────────┐
│ Magic Number (4 bytes)              │  0x45 0x0C 0x45 0x0C
├─────────────────────────────────────┤
│ Bytecode Instructions               │  Variable length
└─────────────────────────────────────┘
```

**Magic Number**: `0x45 0x0C 0x45 0x0C` (4 bytes), as defined in the [Franc C bytecode reference](#bytecode_reference).
- Validates file format at VM initialization
- Invalid magic number triggers immediate error

## Command-Line Interface

```bash
./fcvm <bytecode_file>
```

**Exit Codes**:

| Code | Description |
|------|-------------|
| `0` | Success (or custom return value = 0) |
| `1-255` | Custom exit code (return value mod 256) |
| `84` | Any error (runtime or load-time) |

---

# Architecture Implementation

## Memory Layout

The VM maintains three core structures:

- The operand stack
- The callstack
- Three specific registers

### Operand Stack

Stores temporary computation values, variables and function return values.

```
┌─────────────┬─────────────┬─────────────┐
│  Element 0  │  Element 1  │  Element 2  │
│  (8 bytes)  │  (8 bytes)  │  (8 bytes)  │
└─────────────┴─────────────┴─────────────┘
      ↑
    Stack Top
```

**Properties**:
- Type: `[Word8]` (list of bytes)
- Element size: 8 bytes (64-bit)
- Initial state: One zero element `[0x00 × 8]`
- Max size: 1,000,000 elements (8 MB)
- Operations: PUSH (prepend), POP (drop first 8 bytes)

### Call Stack

Manages function call frames.

```
┌─────────────────────────────────┐
│  Frame: (PC: 0, SP: 0)          │  ← Entry
├─────────────────────────────────┤
│  Frame: (PC: 12, SP: 16)        │
├─────────────────────────────────┤
│  Frame: (PC: 57, SP: 24)        │  ← Current
└─────────────────────────────────┘
```

**Properties**:
- Type: `[(PC, SP)]` (list of tuples)
- Frame content: Return address (PC) + Stack pointer (SP)
- Initial state: Empty `[]`
- Max depth: 1,000,000 frames

**Behavior**:
- `CALL`: Push `(PC+1, SP)`, jump to function
- `RET`: Pop frame, restore context, trim stack
- **Termination**: Empty call stack after `RET` → program ends

### Registers

**Program Counter (PC)**
- Points to current instruction in bytecode
- Initial: 8 (after 4-byte magic number)
- Updates: `+1` (normal), `+9` (with data), or jump target

**Stack Pointer (SP)**
- Marks base of current function's stack frame
- Used for local variable access via `PUSHREL`/`POPREL`
- Modified during `CALL` and `RET`

**Zero Flag (ZF)**
- Type: `Word8` (0 or 1)
- Initial: 1 (true)
- Semantics: `0` if stack top = 0, else `1`
- Set by `ZFLAG`, tested by `ZJMP`

## Instruction Set Overview

The VM implements 40 opcodes across 7 categories:

> [Bytecode Definition](#bytecode_reference).

## Function Call Convention

**Calling sequence**:
```
1. Push function address
2. Execute CALL
   → Saves (PC+1, SP) to call stack
   → Jumps to function
```

**Return sequence**:
```
1. Execute RET
   → Restores PC and SP
   → Trims stack to SP position
   → If call stack empty: program terminates
```

**Stack frame layout**:
```
┌──────────────────┐
│  Caller frame    │
├──────────────────┤  ← SP
│  Local function  │  ← Stack top
└──────────────────┘
```

# Exceptions List

All errors exit with code **84** and write to **stderr**.

## Load-Time Errors

**Invalid Magic Number**
```
Message: *** UNRECONIZED FILE FORMAT
Trigger: First 4 bytes ≠ 0x45 0x0C 0x45 0x0C
```

**File I/O Error**
```
Message: Error with file
Trigger: File not found, permission denied, or read error
```

## Runtime Errors

**Arithmetic Errors**
```
Message: *** 0 CAN'T BE USE in this operation
Trigger: DIV or MOD with divisor = 0
```

**Stack & CallStack Overflow**
```
Message: *** STACK OVERFLOW
Trigger: Operand stack ≥ 1M elements OR call stack ≥ 1M frames
Cause:   Excessive PUSH without POP, or infinite recursion
```

**Stack Underflow**
```
Message: *** STACK ERROR
Trigger: Operation requires elements when stack_size ≤ 1
Affects: All binary/unary ops, CALL, JMP, ZJMP, AFF
```

# Known Caveats

## Undefined Behaviors

**Integer Overflow**
- 64-bit signed integers wrap silently
- Example: `INT64_MAX + 1` → UNDEFINED
- No error raised

**Invalid Opcodes**
- Treated as NOP (PC += 1)
- Corrupted bytecode may execute partially
- No detection mechanism

## Performance Limitations

**List-Based Stack**
- Push/Pop: O(1) ✓
- SP-relative access: O(n) ✗
- Impact: Slow for deep stacks (>1000 elements)

**String Operations**
- `AFFS` creates intermediate structures
- Linear in string length (acceptable)

## Portability Issues

**Platform Word Size**
- `PC` and `SP` use Haskell `Int` type
- 32-bit systems: Max ~2GB bytecode
- 64-bit systems: Max ~8GB bytecode
- Not a practical concern for typical use

**Document Version**: 1.1  
**Last Updated**: November 2025  
**Author** : Acacademie Franc C'aise
