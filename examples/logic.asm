; perform all logic operations
START   LDI   0x0
        ST    0xff0
        LDI   0x6
        ST    0xff1
        JMP   NOT     ; change this to perform a different operation
RETURN  ST    0xfff
DONE    JMP   DONE

; perform NOT
NOT     LD    0xff0
        NORI  0x0     ; NOR with zero is same as NOT
        JMP   RETURN

; perform AND
AND     LD    0xff0
        NORI  0x0     ; NOT of first value
        ST    0xff0
        LD    0xff1
        NORI  0x0     ; NOT of second value
        NOR   0xff0   ; NOR of results
        JMP   RETURN

; perform NAND
NAND    LD    0xff0
        NORI  0x0     ; NOT of first value
        ST    0xff0
        LD    0xff1
        NORI  0x0     ; NOT of second value
        NOR   0xff0   ; NOR of results
        NORI  0x0     ; NOT of result
        JMP   RETURN

; perform OR
OR      LD    0xff0
        NOR   0xff1   ; NOR of values
        NORI  0x0     ; NOT of result
        JMP   RETURN

; perform XOR
XOR     LD    0xff0
        NORI  0x0     ; NOT of first value
        ST    0xff2
        LD    0xff1
        NORI  0x0     ; NOT of second value
        NOR   0xff2   ; NOR of results
        ST    0xff2
        LD    0xff0
        NOR   0xff1   ; NOR of original values
        NOR   0xff2   ; NOR of results
        JMP   RETURN

; perform XNOR
XNOR    LD    0xff0
        NORI  0x0     ; NOT of first value
        ST    0xff2
        LD    0xff1
        NORI  0x0     ; NOT of second value
        NOR   0xff2   ; NOR of results
        ST    0xff2
        LD    0xff0
        NOR   0xff1   ; NOR of original values
        NOR   0xff2   ; NOR of results
        NORI  0x0     ; NOT of result
        JMP   RETURN
