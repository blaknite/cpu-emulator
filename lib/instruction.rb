class Instruction
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI LDM ST STC STM NOR NORI ADD ADDI CMP CMPI)

  def self.from_opcode(opcode, computer)
    Object.const_get("Instruction::#{OPCODE_MAP[opcode]}").new(computer)
  end

  def initialize(computer)
    @computer = computer
    @steps = []
  end

  def name
    self.class.name.split('::').last
  end

  def clock!
    @steps[@computer.ic.value].call if @steps[@computer.ic.value]
    @steps[@computer.ic.value + 1] ? @computer.ic.value += 1 : @computer.ic.value = 0
  end
end

class Instruction::NOP < Instruction
 def initialize(computer)
   super(computer)

   @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
   @steps << -> { @computer.pc.value += 1 }
 end
end

class Instruction::JMP < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value = @operand }
  end
end

class Instruction::JC < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.c.value == 1 ? @computer.pc.value = @operand : @computer.pc.value += 1 }
  end
end

class Instruction::JZ < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.z.value == 1 ? @computer.pc.value = @operand : @computer.pc.value += 1 }
  end
end

class Instruction::LD < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.r[@computer.ram[@computer.pc.value].value].value }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> { @computer.pc.value += 1 }
  end
end

class Instruction::LDI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> { @computer.pc.value += 1 }
  end
end

class Instruction::LDM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.bus.value = @computer.ram[@operand].value }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end

class Instruction::ST < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.a.value }
    @steps << -> { @computer.r[@computer.ram[@computer.pc.value].value].value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> { @computer.pc.value += 1 }
  end
end

class Instruction::STC < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.c.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
  end
end

class Instruction::STM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.bus.value = @computer.a.value }
    @steps << -> { @computer.ram[@operand].value = @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end

class Instruction::NOR < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.r[@computer.ram[@computer.pc.value].value].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = ~(@computer.ta.value | @computer.tb.value)
      @computer.bus.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end

class Instruction::NORI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = ~(@computer.ta.value | @computer.tb.value)
      @computer.bus.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end

class Instruction::NORM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.bus.value = @computer.ram[@operand].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = ~(@computer.ta.value | @computer.tb.value)
      @computer.bus.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> { @computer.pc.value += 1 }
  end
end

class Instruction::ADD < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.r[@computer.ram[@computer.pc.value].value].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value + @computer.c.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end

class Instruction::ADDI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value + @computer.c.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end

class Instruction::ADDM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.bus.value = @computer.ram[@operand].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value + @computer.c.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> { @computer.pc.value += 1 }
  end
end

class Instruction::CMP < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.r[@computer.ram[@computer.pc.value].value].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> {
      result = @computer.ta.value - @computer.tb.value
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.ic.value = 0 }
  end
end

class Instruction::CMPI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> {
      result = @computer.ta.value - @computer.tb.value
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.ic.value = 0 }
  end
end

class Instruction::CMPM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @opcode = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand = @computer.ram[@computer.pc.value].value << 0x8 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value << 0x4 }
    @steps << -> { @computer.pc.value += 1 }
    @steps << -> { @operand += @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.bus.value = @computer.ram[@operand].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> {
      result = @computer.ta.value - @computer.tb.value
      @computer.c.value = result[4]
      @computer.z.value = result & 0x0f == 0 ? 1 : 0
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
  end
end
