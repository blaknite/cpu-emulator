; calculate 4 + 4

START
      A = 0x4
      B = 0x8

      LDI   A
      ADDI  B
      ST    0xfff
DONE
      JMP   DONE
