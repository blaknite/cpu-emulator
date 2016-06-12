class Operation
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI SUB SUBI)

  def self.from_opcode(opcode, computer)
    Object.const_get("Operation::#{OPCODE_MAP[opcode]}").new(computer)
  end

  def initialize(computer)
    @computer = computer
    @steps = []
    8.times{ @steps << -> {} }
  end

  def clock
    @steps.shift.call
  end

  def complete?
    @steps.empty?
  end
end

class Operation::NOP < Operation
 def initialize(computer)
   super(computer)
   @steps[0] = -> { @computer.pc.incr }
 end
end

class Operation::JMP < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.incr }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.get].get << 0x8 }
    @steps[2] = -> { @computer.pc.incr }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.get].get << 0x4 }
    @steps[4] = -> { @computer.pc.incr }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.get].get }
    @steps[6] = -> { @computer.pc.set(@operand) }
  end
end

class Operation::JC < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.incr }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.get].get << 0x8 }
    @steps[2] = -> { @computer.pc.incr }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.get].get << 0x4 }
    @steps[4] = -> { @computer.pc.incr }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.get].get }
    @steps[6] = -> { @computer.c.get == 1 ? @computer.pc.set(@operand) : @computer.pc.incr }
  end
end

class Operation::JZ < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.incr }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.get].get << 0x8 }
    @steps[2] = -> { @computer.pc.incr }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.get].get << 0x4 }
    @steps[4] = -> { @computer.pc.incr }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.get].get }
    @steps[6] = -> { @computer.z.get == 1 ? @computer.pc.set(@operand) : @computer.pc.incr }
  end
end

class Operation::LD < Operation

end

class Operation::LDI < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.incr }
    @steps[1] = -> { @computer.a.set(@computer.ram[@computer.pc.get].get) }
    @steps[2] = -> { @computer.pc.incr }
  end
end

class Operation::ST < Operation

end

class Operation::STC < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.incr }
    @steps[1] = -> { @computer.c.set(@computer.ram[@computer.pc.get].get) }
    @steps[2] = -> { @computer.pc.incr }
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
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.incr }
    @steps[1] = -> {
      result = @computer.a.get + @computer.ram[@computer.pc.get].get
      @computer.a.set(result)
      @computer.c.set(result > 0xf ? 1 : 0)
    }
    @steps[2] = -> { @computer.pc.incr }
  end
end

class Operation::SUB < Operation

end

class Operation::SUBI < Operation

end
