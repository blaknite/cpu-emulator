; perform all arithmetic operations

A = ZERO
B = 0x1
TEMP = 0xe
ZERO = 0xf

START   LDI   0x0
        ST    ZERO
        LDI   0x6
        ST    A
        LDI   0x2
        ST    B
        CALL  MUL     ; change this to perform a different operation

STORE   STM   0xfff   ; store result

DONE    JMP   DONE

; perform subtraction
SUB     LD    B       ; load B
        NOR   ZERO
        ADDI  0x1     ; 2's compliment of B
        ADD   A       ; add A to B
        RET

; perform multiplication
MUL     LD    B
        NOR   ZERO
        ADDI  0x1     ; 2's compliment of B
        ST    B
        LD    ZERO
        ST    TEMP
MUL2    ADD   A       ; add A to TEMP
        ST    TEMP    ; store result
        LD    B       ; load B
        ADDI  0x1     ; ADD 1 to B
        JZ    MUL3    ; we're done if B == 0
        ST    B       ; store B
        LD    TEMP    ; load TEMP
        JMP   MUL2    ; loop
MUL3    RET
