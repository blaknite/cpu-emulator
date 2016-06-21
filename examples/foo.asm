; calculate 4 + 4

START   LDI   0x0a
        CALL  PRINT
        LDI   'L'
        CALL  PRINT
        LDI   'o'
        CALL  PRINT
        LDI   'a'
        CALL  PRINT
        LDI   'd'
        CALL  PRINT
        LDI   'i'
        CALL  PRINT
        LDI   'n'
        CALL  PRINT
        LDI   'g'
        CALL  PRINT
        LDI   '.'
        CALL  PRINT
        LDI   '.'
        CALL  PRINT
        LDI   '.'
        CALL  PRINT
        LDI   0x0a
        CALL  PRINT

INPUT   LDM   0xff0
        CMPI  0
        JZ    INPUT
        CALL  PRINT
        JMP   INPUT

PRINT   STM   0xff8
        RET
