class Instruction < Transaction
  OPCODES = {
    JMP:  2,
    JC:   2,
    JZ:   2,
    CALL: 2,
    RET:  1,
    LD:   1,
    LDI:  2,
    LDM:  2,
    ST:   1,
    STM:  2,
    NOR:  1,
    NORI: 2,
    ADD:  1,
    ADDI: 2,
    CMP:  1,
    CMPI: 2,
  }

  def self.get(opcode)
    validate!(opcode)
    super
  end

  def self.define(opcode, &block)
    validate!(opcode)
    super
  end

  def self.validate!(opcode)
    fail("invalid instruction: #{opcode}") unless OPCODES.keys.include?(opcode)
  end
end
