; perform all arithmetic operations

A = 0x0
B = 0x1
TEMP = 0xf

START   LDI   0x6
        ST    A
        LDI   0x2
        ST    B
        JMP   MUL     ; change this to perform a different operation

STORE   STM   0xfff   ; store result

DONE    JMP   DONE

; perform subtraction
SUB     LDI   0x0
        STC   0x0
        LD    B       ; load B
        NORI  0x0     ; 2's compliment of B
        ADDI  0x1
        STC   0x0
        ADD   A       ; add A to B
        JMP   STORE

; perform multiplication
MUL     LDI   0x0
        STC   0x0
        ST    TEMP
MUL2    LD    TEMP    ; load result
        STC   0x0
        ADD   A       ; add A to result
        ST    TEMP    ; store result
        LD    B       ; load B
        STC   0x0
        ADDI  0xf     ; subtract 1 from B
        JZ    STORE   ; we're done if B == 0
        ST    B       ; store B
        JMP   MUL2    ; loop
