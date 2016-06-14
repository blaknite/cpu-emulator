; perform all arithmetic operations
START   LDI   0x6
        ST    0xff0
        LDI   0x2
        ST    0xff1
        JMP   MUL     ; change this to perform a different operation
DONE    JMP   DONE

; perform subtraction
SUB     LDI   0x0
        STC   0x0
        LD    0xff1   ; load second value
        NORI  0x0     ; 2's compliment
        ADDI  0x1
        STC   0x0
        ADD   0xff0   ; add to first value
        ST    0xfff   ; store result
        JMP   DONE    ; job done
