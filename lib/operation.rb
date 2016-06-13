class Operation
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI CMP CMPI)

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
   @steps[0] = -> { @computer.pc.value += 1 }
 end
end

class Operation::JMP < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> { @computer.pc.value = @operand }
  end
end

class Operation::JC < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> { @computer.c.value == 1 ? @computer.pc.value = @operand : @computer.pc.value += 1 }
  end
end

class Operation::JZ < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> { @computer.z.value == 1 ? @computer.pc.value = @operand : @computer.pc.value += 1 }
  end
end

class Operation::LD < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> { @computer.a.value = @computer.ram[@operand].value }
    @steps[7] = -> { @computer.pc.value += 1 }
  end
end

class Operation::LDI < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @computer.a.value = @computer.ram[@computer.pc.value].value }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end

class Operation::ST < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> { @computer.ram[@operand].value = @computer.a.value }
    @steps[7] = -> { @computer.pc.value += 1 }
  end
end

class Operation::STC < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @computer.c.value = @computer.ram[@computer.pc.value].value }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end

class Operation::IN < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @computer.a.value = @computer.in[@computer.ram[@computer.pc.value].value].value }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end

class Operation::OUT < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @computer.out[@computer.ram[@computer.pc.value].value].value = @computer.a.value }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end

class Operation::NOR < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> {
      result = ~(@computer.a.value | @computer.ram[@operand].value)
      @computer.a.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps[7] = -> { @computer.pc.value += 1 }
  end
end

class Operation::NORI < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> {
      result = ~(@computer.a.value | @computer.ram[@computer.pc.value].value)
      @computer.a.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end

class Operation::ADD < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> {
      result = @computer.a.value + @computer.ram[@operand].value
      @computer.a.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps[7] = -> { @computer.pc.value += 1 }
  end
end

class Operation::ADDI < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> {
      result = @computer.a.value + @computer.ram[@computer.pc.value].value
      @computer.a.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end

class Operation::CMP < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps[2] = -> { @computer.pc.value += 1 }
    @steps[3] = -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps[4] = -> { @computer.pc.value += 1 }
    @steps[5] = -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps[6] = -> {
      result = @computer.a.value - @computer.ram[@operand].value
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps[7] = -> { @computer.pc.value += 1 }
  end
end

class Operation::CMPI < Operation
  def initialize(computer)
    super(computer)
    @steps[0] = -> { @computer.pc.value += 1 }
    @steps[1] = -> {
      result = @computer.a.value - @computer.ram[@computer.pc.value].value
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps[2] = -> { @computer.pc.value += 1 }
  end
end
