class Operation
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI SUB SUBI)

  def self.from_instruction(computer, instruction)
    Object.const_get("Operation::#{OPCODE_MAP[instruction.opcode]}").new(computer, instruction.operand)
  end

  def initialize(computer, operand)
    @computer = computer
    @operand = operand
  end

  def perform
    @computer.pc.set(@computer.pc.get + 1)
  end
end

class Operation::NOP < Operation

end

class Operation::JMP < Operation

end

class Operation::JC < Operation

end

class Operation::JZ < Operation

end

class Operation::LD < Operation

end

class Operation::LDI < Operation

end

class Operation::ST < Operation

end

class Operation::STC < Operation
  def perform
    @computer.c.set(@operand)
    super
  end
end

class Operation::IN < Operation

end

class Operation::OUT < Operation

end

class Operation::NOR < Operation

end

class Operation::NORI < Operation

end

class Operation::ADD < Operation

end

class Operation::ADDI < Operation

end

class Operation::SUB < Operation

end

class Operation::SUBI < Operation

end
