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

; perform multiplication
MUL     LDI   0x0
        STC   0x0
        ST    0xfff
MUL2    LD    0xfff   ; load result
        STC   0x0
        ADD   0xff0   ; add first value to result
        ST    0xfff   ; store result
        LD    0xff1   ; load second value
        STC   0x0
        ADDI  0xf     ; subtract 1
        JZ    DONE    ; job done
        ST    0xff1   ; store decremented value
        JMP   MUL2    ; loop
