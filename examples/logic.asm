; perform all logic operations

A = 0x0
B = 0x1
TEMP = 0xe
ZERO = 0xf

START   LDI   0
        ST    ZERO
        ST    A
        LDI   6
        ST    B
        CALL  XNOR    ; change this to perform a different operation

STORE   STM   0xfff

DONE    JMP   DONE

; perform NOT
NOT     LD    A
        NOR   ZERO    ; NOR with zero is same as NOT
        RET

; perform AND
AND     LD    A
        NOR   ZERO    ; NOT of first value
        ST    A
        LD    B
        NOR   ZERO    ; NOT of second value
        NOR   A       ; NOR of results
        RET

; perform NAND
NAND    LD    A
        NOR   ZERO    ; NOT of first value
        ST    A
        LD    B
        NOR   ZERO    ; NOT of second value
        NOR   A       ; NOR of results
        NOR   ZERO    ; NOT of result
        RET

; perform OR
OR      LD    A
        NOR   B       ; NOR of values
        NOR   ZERO    ; NOT of result
        RET

; perform XOR
XOR     LD    A
        NOR   ZERO    ; NOT of first value
        ST    TEMP
        LD    B
        NOR   ZERO    ; NOT of second value
        NOR   TEMP    ; NOR of results
        ST    TEMP
        LD    A
        NOR   B       ; NOR of original values
        NOR   TEMP    ; NOR of results
        RET

; perform XNOR
XNOR    LD    A
        NOR   ZERO    ; NOT of first value
        ST    TEMP
        LD    B
        NOR   ZERO    ; NOT of second value
        NOR   TEMP    ; NOR of results
        ST    TEMP
        LD    A
        NOR   B       ; NOR of original values
        NOR   TEMP    ; NOR of results
        NOR   ZERO    ; NOT of result
        RET
