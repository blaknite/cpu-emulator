; perform all arithmetic operations
START   LDI   0x0
        ST    0xff0
        LDI   0x6
        ST    0xff1
        JMP   SUB     ; change this to perform a different operation
RETURN  ST    0xfff
DONE    JMP   DONE

; perform SUB
SUB     LDI   0x0
        STC   0x1
        LD    0xff0
        ADD   0xff1
        JMP   RETURN
