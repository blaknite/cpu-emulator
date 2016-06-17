; calculate 4 + 4

A = 0x4
B = 0x8

START   LDI   A
        ADDI  B
        ST    0xfff

DONE    JMP   DONE
