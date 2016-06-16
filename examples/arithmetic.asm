; perform all arithmetic operations

A = 0xff0
B = 0xff0
RESULT = 0xfff

START
        LDI   0x6
        ST    A
        LDI   0x2
        ST    B
        JMP   MUL     ; change this to perform a different operation

DONE    JMP   DONE

; perform subtraction
SUB     LDI   0x0
        STC   0x0
        LD    B       ; load B
        NORI  0x0     ; 2's compliment of B
        ADDI  0x1
        STC   0x0
        ADD   A       ; add A to B
        ST    RESULT  ; store result
        JMP   DONE

; perform multiplication
MUL     LDI   0x0
        STC   0x0
        ST    RESULT
MUL2    LD    RESULT  ; load result
        STC   0x0
        ADD   A       ; add A to result
        ST    RESULT  ; store result
        LD    B       ; load B value
        STC   0x0
        ADDI  0xf     ; subtract 1 from B
        JZ    DONE    ; we're done if B == 0
        ST    B       ; store B
        JMP   MUL2    ; loop
