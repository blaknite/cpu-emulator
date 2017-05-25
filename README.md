# Emulating an 8-bit Computer design in Ruby

[![Build Status](https://travis-ci.org/blaknite/cpu-emulator.svg?branch=master)](https://travis-ci.org/blaknite/cpu-emulator)

Started out as a 4-bit computer but grew as I wanted to do more with it. Original idea here:

https://www.thelanbox.com.au/forum/t/building-a-4-bit-computer-from-scratch

The CPU uses a minimal instruction set with provisions for conditional jumps and subroutines.
Each op-code is 4 bits with instructions being either 8 or 16 bits in length.

## Schematic

![schematic diagram](https://d1bh5m8o3ysx9y.cloudfront.net/uploads/images/943c727f-70fc-4670-8026-ad860d14fe9d.png)

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
| op-code | ignored |     data      |   Immediate operations use second byte for data.
+-----------------------------------+
```

### Op-Codes
```
HEX : BIN  : CODE : T : DESCRIPTION
----+------+------+---+------------------------------------------------------------
0x0 : 0000 : JMP  :  9 : Jump to memory address unconditionally.
0x1 : 0001 : JC   :  9 : Jump to memory address if carry.
0x2 : 0010 : JZ   :  9 : Jump to memory address if zero.
0x3 : 0011 : CALL : 10 : Jump to memory address and save previous address to stack.
0x4 : 0100 : RET  :  5 : Jump to memory address one down in stack.
0x5 : 0101 : LD   :  7 : Load register to accumulator.
0x6 : 0110 : LDI  : 11 : Load immediate value to accumulator.
0x7 : 0111 : LDM  : 11 : Load memory to accumulator.
0x8 : 1000 : ST   :  7 : Store accumulator in register.
0x9 : 1001 : STM  : 11 : Store accumulator in memory.
0xa : 1010 : NOR  : 10 : Logical NOR of register and accumulator.
0xb : 1011 : NORI : 14 : Logical NOR of immediate value and accumulator.
0xc : 1100 : ADD  : 10 : Add register to accumulator.
0xd : 1101 : ADDI : 14 : Add immediate value to accumulator.
0xe : 1110 : CMP  :  8 : Compare register with accumulator.
0xf : 1111 : CMPI : 12 : Compare immediate value with accumulator.

* T is the number of clock cycles required to perform the instruction
```

## Memory-mapped I/O
Memory addresses `0xff0` to `0xff7` are reserved as input registers.
Memory addresses `0xff8` to `0xfff` are reserved as output registers.
Writing to an input address is ignored. Reading from an output address reads the most recent output.

## Example

```
$ cat examples/test.asm
; calculate 4 + 4

START   LDI   0x4
        ADDI  0x4
        STM   0xfff

DONE    JMP   DONE

$ ruby bin/assemble.rb examples/test.asm examples/test.bin
Assembling program..........complete!
0x60 0x04 0xd0 0x04 0x9f 0xff 0x00 0x06

$ ruby bin/run.rb examples/test.bin
Program loaded!
Running...
0x000 - |####|####|###| - LDI
0x002 - |####|####|######| - ADDI
0x004 - |####|####|###| - STM
0x006 - |####|####|#| - JMP
...
```
