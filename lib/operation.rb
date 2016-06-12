class Operation
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI SUB SUBI)

  def self.from_opcode(opcode, computer)
    Object.const_get("Operation::#{OPCODE_MAP[opcode]}").new(computer)
  end

  def initialize(computer)
    @computer = computer
    @steps = []
  end

  def clock
    @steps.shift.call
  end

  def complete?
    @steps.empty?
  end

  private

    def prepend_step(step)
      @steps.unshift(step)
    end

    def append_step(step)
      @steps.push(step)
    end
end

class Operation::NOP < Operation
 def initialize(computer)
   super(computer)
   prepend_step -> { @computer.pc.incr }
 end
end

class Operation::JMP < Operation
  def initialize(computer)
    super(computer)
    append_step -> { @computer.pc.incr }
    append_step -> { @operand = @computer.ram[@computer.pc.get].get << 0x8 }
    append_step -> { @computer.pc.incr }
    append_step -> { @operand += @computer.ram[@computer.pc.get].get << 0x4 }
    append_step -> { @computer.pc.incr }
    append_step -> { @operand += @computer.ram[@computer.pc.get].get }
    append_step -> { @computer.pc.set(@operand) }
  end
end

class Operation::JC < Operation

end

class Operation::JZ < Operation

end

class Operation::LD < Operation

end

class Operation::LDI < Operation
  def initialize(computer)
    super(computer)
    append_step -> { @computer.pc.incr }
    append_step -> { @computer.a.set(@computer.ram[@computer.pc.get].get) }
    append_step -> { @computer.pc.incr }
  end
end

class Operation::ST < Operation

end

class Operation::STC < Operation
  def initialize(computer)
    super(computer)
    append_step -> { @computer.pc.incr }
    append_step -> { @computer.c.set(@computer.ram[@computer.pc.get].get) }
    append_step -> { @computer.pc.incr }
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
    append_step -> { @computer.pc.incr }
    append_step -> {
      result = @computer.a.get + @computer.ram[@computer.pc.get].get
      @computer.a.set(result)
      @computer.c.set(result > 0xf ? 1 : 0)
    }
    append_step -> { @computer.pc.incr }
  end
end

class Operation::SUB < Operation

end

class Operation::SUBI < Operation

end
