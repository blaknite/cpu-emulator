; perform all logic operations

A = 0xff0
B = 0xff1
TEMP = 0xff2

START   LDI   0x0
        ST    A
        LDI   0x6
        ST    B
        JMP   NOT     ; change this to perform a different operation

STORE  ST    0xfff

DONE   JMP   DONE

; perform NOT
NOT     LD    A
        NORI  0x0     ; NOR with zero is same as NOT
        JMP   STORE

; perform AND
AND     LD    A
        NORI  0x0     ; NOT of first value
        ST    A
        LD    B
        NORI  0x0     ; NOT of second value
        NOR   A       ; NOR of results
        JMP   STORE

; perform NAND
NAND    LD    A
        NORI  0x0     ; NOT of first value
        ST    A
        LD    B
        NORI  0x0     ; NOT of second value
        NOR   A       ; NOR of results
        NORI  0x0     ; NOT of result
        JMP   STORE

; perform OR
OR      LD    A
        NOR   B       ; NOR of values
        NORI  0x0     ; NOT of result
        JMP   STORE

; perform XOR
XOR     LD    A
        NORI  0x0     ; NOT of first value
        ST    TEMP
        LD    B
        NORI  0x0     ; NOT of second value
        NOR   TEMP    ; NOR of results
        ST    TEMP
        LD    A
        NOR   B       ; NOR of original values
        NOR   TEMP    ; NOR of results
        JMP   STORE

; perform XNOR
XNOR    LD    A
        NORI  0x0     ; NOT of first value
        ST    TEMP
        LD    B
        NORI  0x0     ; NOT of second value
        NOR   TEMP    ; NOR of results
        ST    TEMP
        LD    A
        NOR   B       ; NOR of original values
        NOR   TEMP    ; NOR of results
        NORI  0x0     ; NOT of result
        JMP   STORE
