H = 0x0
L = 0x1

MEM_H = 0x2
MEM_L = 0x3

X_POS = 0xc
Y_POS = 0xd

TEMP_A = 0xa
TEMP_B = 0xb

RX = 0xe
TX = 0xf

WAIT    LD    RX
        CMPI  0
        JZ    WAIT

        CALL  CLS
        CALL  HOME

        LDI   '3'
        ST    X_POS
        LDI   '2'
        ST    Y_POS
        CALL  MOVCUR

RUN     LDI   'H'
        ST    TX
        LDI   'e'
        ST    TX
        LDI   'l'
        ST    TX
        LDI   'l'
        ST    TX
        LDI   'o'
        ST    TX
        LDI   ' '
        ST    TX
        LDI   'W'
        ST    TX
        LDI   'o'
        ST    TX
        LDI   'r'
        ST    TX
        LDI   'l'
        ST    TX
        LDI   'd'
        ST    TX
        LDI   '!'
        ST    TX
        JMP   WAIT

DONE    JMP   DONE

ESC     LDI   0x1B
        ST    TX
        LDI   '['
        ST    TX
        RET

CLS     CALL  ESC
        LDI   '2'
        ST    TX
        LDI   'J'
        ST    TX
        RET

HOME    CALL  ESC
        LDI   'H'
        ST    TX
        RET

MOVCUR  CALL  ESC
        LD    Y_POS
        ST    TX
        LDI   ';'
        ST    TX
        LD    X_POS
        ST    TX
        LDI   'H'
        ST    TX
        RET
