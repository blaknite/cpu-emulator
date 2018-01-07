; Find the sum of all the multiples of 3 or 5 below 10

MAX     = 0x0
CURRENT = 0x1
THREE   = 0x2
FIVE    = 0x3
TEMP_A  = 0xa
TEMP_B  = 0xb
RESULT  = 0xfff

START   LDI   10
        ST    MAX
        LDI   3
        ST    THREE
        LDI   5
        ST    FIVE
        LDI   1
        ST    CURRENT
        JMP   CHK_3

DONE    JMP   DONE

CHK_3   LD    CURRENT
        CALL  COMP
        ST    TEMP_A
        LD    THREE
        ST    TEMP_B
        LD    TEMP_A
LOOP_3  ADD   TEMP_B
        JZ    VALID
        JC    CHK_5
        JMP   LOOP_3

CHK_5   LD    CURRENT
        CALL  COMP
        ST    TEMP_A
        LD    FIVE
        ST    TEMP_B
        LD    TEMP_A
LOOP_5  ADD   TEMP_B
        JZ    VALID
        JC    NEXT
        JMP   LOOP_5

VALID   LDM   RESULT
        ADD   CURRENT
        STM   RESULT
        JMP   NEXT

NEXT    LD    CURRENT
        ADDI  1
        CMP   MAX
        JZ    DONE
        ST    CURRENT
        JMP   CHK_3

COMP    NORI  0
        ADDI  1
        RET
