; perform all logic operations
START   LDI   0x0
        ST    0xff0
        LDI   0x6
        ST    0xff1
        JMP   NOT     ; change this to perform a different operation
RETURN  ST    0xfff
DONE    JMP   DONE

; perform NOT
NOT     LDI   0x0
        STC   0x0
        LD    0xff0
        NORI  0x0
        JMP   RETURN

; perform AND
AND     LDI   0x0
        STC   0x0
        LD    0xff0
        NORI  0x0
        ST    0xff2
        LD    0xff1
        NORI  0x0
        NOR   0xff2
        JMP   RETURN

; perform NAND
NAND    LDI   0x0
        STC   0x0
        LD    0xff0
        NORI  0x0
        ST    0xff2
        LD    0xff1
        NORI  0x0
        NOR   0xff2
        NORI  0x0
        JMP   RETURN

; perform OR
OR      LDI   0x0
        STC   0x0
        LD    0xff0
        NOR   0xff1
        NORI  0x0
        JMP   RETURN

; perform XOR
XOR     LDI   0x0
        STC   0x0
        LD    0xff0
        NORI  0x0
        ST    0xff2
        LD    0xff1
        NORI  0x0
        NOR   0xff2
        ST    0xff2
        LD    0xff0
        NOR   0xff1
        NOR   0xff2
        JMP   RETURN

; perform XNOR
XNOR    LDI   0x0
        STC   0x0
        LD    0xff0
        NORI  0x0
        ST    0xff2
        LD    0xff1
        NORI  0x0
        NOR   0xff2
        ST    0xff2
        LD    0xff0
        NOR   0xff1
        NOR   0xff2
        NORI  0x0
        JMP   RETURN
