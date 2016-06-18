; calculate 4 + 4

A = 0x4
B = 0x8

START   LDI   A
        STC   0x0
        ADDI  B
        STM   0xfff

DONE    JMP   DONE
