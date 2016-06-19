# Emulating an 8-bit Computer design in Ruby

Started out as a 4-bit computer but grew as I wanted to do more with it. Original idea here:

https://www.thelanbox.com.au/forum/t/building-a-4-bit-computer-from-scratch

The CPU uses a minimal instruction set with provisions for conditional jumps and subroutines.
Each op-code is 4 bits with instructions being either 8 or 16 bits in length.

## Instructions

### Single-byte Instructions
```
+-------------------+
| o o o o | d d d d |
+-------------------+

+-------------------+
| op-code | ignored |   RET ignores data.
+-------------------+

+-------------------+
| op-code | address |   Register operations use 4-bits for address.
+-------------------+
```

### Double-byte Instructions
```
+-----------------------------------+
| o o o o | d d d d d d d d d d d d |
+-----------------------------------+

+-----------------------------------+
| op-code |      memory address     |   Jump and memory operations use 12-bits for address.
+-----------------------------------+

+-----------------------------------+
| op-code | ignoerd |     data      |   Immediate operations use second byte for data.
+-----------------------------------+
```

### Op-Codes
```
HEX : BIN  : CODE : T : DESCRIPTION
----+------+------+---+-----------------------------------------------------------
0x0 : 0000 : JMP  : 2 : Jump to memory address unconditionally.
0x1 : 0001 : JC   : 2 : Jump to memory address if carry.
0x2 : 0010 : JZ   : 2 : Jump to memory address if zero.
0x3 : 0011 : CALL : 2 : Jump to memory address and save previous address to stack.
0x4 : 0100 : RET  : 1 : Jump to memory address one down in stack.
0x5 : 0101 : LD   : 2 : Load register to accumulator.
0x6 : 0110 : LDI  : 3 : Load immediate value to accumulator.
0x7 : 0111 : LDM  : 3 : Load memory to accumulator.
0x8 : 1000 : ST   : 2 : Store accumulator in register
0x9 : 1001 : STM  : 3 : Store accumulator in memory.
0xa : 1010 : NOR  : 3 : Logical NOR of register and accumulator.
0xb : 1011 : NORI : 4 : Logical NOR of immediate value and accumulator.
0xc : 1100 : ADD  : 3 : Add register to accumulator.
0xd : 1101 : ADDI : 4 : Add immediate value to accumulator.
0xe : 1110 : CMP  : 2 : Compare register with accumulator.
0xf : 1111 : CMPI : 3 : Compare immediate value with accumulator.
```

## Example

```
$ cat examples/foo.asm
; calculate 4 + 4

A = 0x4
B = 0x8

START   LDI   A
        ADDI  B
        STM   0xfff

DONE    JMP   DONE

$ ruby bin/assemble.rb examples/foo.asm examples/foo.bin
Assembling program....................complete!
0x60 0x4 0xd0 0x8 0x9f 0xff 0x0 0x6

$ ruby bin/run.rb examples/foo.bin
Running...
0x000 - LDI  - |#########|
0x002 - ADDI - |############|
0x004 - STM  - |#########|
0x006 - JMP  - |######|
...
```
