# Emulating my 4-bit Computer design in Ruby

https://www.thelanbox.com.au/forum/t/building-a-4-bit-computer-from-scratch

No doubt I'll find ways it doesn't work and the design will change.

```
0000 : NOP  : No Operation.
0001 : JMP  : Jump to program address unconditionally.
0010 : JC   : Jump to program address if carry.
0011 : JZ   : Jump to program address if zero.
0100 : LDM  : Load memory to accumulator.
0101 : LDI  : Load immediate value to accumulator.
0110 : LDR  : Load register to accumulator.
0111 : STM  : Store accumulator in memory.
1000 : STC  : Set carry in to immediate value.
1001 : STR  : Store accumulator in register
1010 : NOR  : Logical NOR of register and accumulator.
1011 : NORI : Logical NOR of immediate value and accumulator.
1100 : ADD  : Add register to accumulator.
1101 : ADDI : Add immediate value to accumulator.
1110 : CMP  : Compare register with accumulator.
1111 : CMPI : Compare immediate value with accumulator.
```

Instructions 2-4 nibbles in length. Shared memory of 4096 nibbles. 16 addressable input and output busses.

## Example

```
$ cat examples/foo.asm
; calculate 4 + 4
START LDI   0x4
      ADDI  0x4
      STM   0xfff
DONE  JMP   DONE

$ ruby bin/assemble.rb examples/foo.asm examples/foo.bin
Assembling program........complete!
0x5 0x4 0xd 0x4 0x6 0xf 0xf 0xf 0x1 0x0 0x0 0x8

$ ruby bin/run.rb examples/foo.bin
Running...
0x000 - LDI  - |########|
0x002 - ADDI - |########|
0x004 - STM  - |########|
0x008 - JMP  - |########|
...
```
