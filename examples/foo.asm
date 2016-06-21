; Print input to output

START   LDI   0x0a
        CALL  PRINT

INPUT   LDM   0xff0
        CMPI  0
        JZ    INPUT
        CALL  PRINT
        JMP   INPUT

PRINT   STM   0xff8
        RET
