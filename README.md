# Emulating my 4-bit Computer design in Ruby

https://www.thelanbox.com.au/forum/t/building-a-4-bit-computer-from-scratch

No doubt I'll find ways it doesn't work and the design will change.

```
0000 : NOP  : No Operation.
0001 : JMP  : Jump to program address unconditionally.
0010 : JC   : Jump to program address if carry.
0011 : JZ   : Jump to program address if zero.
0100 : LD   : Load register to accumulator.
0101 : LDI  : Load immediate value to accumulator.
0110 : ST   : Store accumulator in register.
0111 : STC  : Set carry in to immediate value.
1000 : IN   : Load a value from the input bus.
1001 : OUT  : Send a value on the output bus.
1010 : NOR  : Logical NOR of register and accumulator.
1011 : NORI : Logical NOR of immediate value and accumulator.
1100 : ADD  : Add register to accumulator.
1101 : ADDI : Add immediate value to accumulator.
1110 : CMP  : Compare register with accumulator.
1111 : CMPI : Compare immediate value with accumulator.
```

Instructions 2-4 nibbles in length. Shared memory of 4096 nibbles. 16 addressable input and output busses.

```ruby
# initialize a computer
c = Computer.new

# load 4 to a, add 4, store to 0xfff and then hang
c.load_program("0x5 0x4 0xd 0x4 0x6 0xf 0xf 0xf 0x1 0x0 0x0 0x8")

# run the above program
c.run
```
