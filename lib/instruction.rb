class Instruction
  OPCODE_MAP = %w(JMP JC JZ CALL RET LD LDI LDM ST STM NOR NORI ADD ADDI CMP CMPI)

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

   @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
   @steps << -> { @computer.i.value = @computer.bus.value << 0x08 }
   @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
   }
 end
end

class Instruction::JMP < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value = @computer.i.value & 0xfff
    }
  end
end

class Instruction::JC < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.c.value == 1 ? @computer.pc.value = @computer.i.value & 0xfff : @computer.pc.value += 1
    }
  end
end

class Instruction::JZ < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.z.value == 1 ? @computer.pc.value = @computer.i.value & 0xfff : @computer.pc.value += 1
    }
  end
end

class Instruction::CALL < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
      @computer.stack.unshift(Register.new(12))
      @computer.stack.pop
      @computer.pc.value = @computer.i.value & 0xfff
    }
  end
end

class Instruction::RET < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x08 }
    @steps << -> {
      @computer.stack.shift
      @computer.stack.push(Register.new(12))
    }
  end
end

class Instruction::LD < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.r[@computer.i.value >> 8 & 0xf].value }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::LDI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.i.value & 0xff }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::LDM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.i.value & 0xfff].value }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::ST < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.a.value }
    @steps << -> { @computer.r[@computer.i.value >> 8 & 0xf].value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::STC < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.i.value >> 8 & 0xf }
    @steps << -> { @computer.c.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::STM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.a.value }
    @steps << -> { @computer.ram[@computer.i.value & 0xfff].value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::NOR < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.r[@computer.i.value >> 8 & 0xf].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = ~(@computer.ta.value | @computer.tb.value)
      @computer.bus.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::NORI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.i.value & 0xff }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = ~(@computer.ta.value | @computer.tb.value)
      @computer.bus.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::NORM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.i.value & 0xfff].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = ~(@computer.ta.value | @computer.tb.value)
      @computer.bus.value = result
      @computer.c.value = 0
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::ADD < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.r[@computer.i.value >> 8 & 0xf].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::ADDI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.i.value & 0xff }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::ADDM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.i.value & 0xfff].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end

class Instruction::CMP < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.r[@computer.i.value >> 8 & 0xf].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> {
      result = @computer.ta.value - @computer.tb.value
      @computer.c.value = result[4]
      @computer.z.value = result & 0xf == 0 ? 1 : 0
      @computer.bus.value = 0
    }
  end
end

class Instruction::CMPI < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.i.value & 0xff }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> {
      result = @computer.ta.value - @computer.tb.value
      @computer.c.value = result[4]
      @computer.z.value = result & 0xff == 0 ? 1 : 0
      @computer.bus.value = 0
    }
  end
end

class Instruction::CMPM < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
     @computer.bus.value = 0
     @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value += @computer.bus.value }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = @computer.ram[@computer.i.value & 0xfff].value }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> {
      result = @computer.ta.value - @computer.tb.value
      @computer.c.value = result[4]
      @computer.z.value = result & 0xf == 0 ? 1 : 0
      @computer.bus.value = 0
    }
  end
end

class Instruction::INC < Instruction
  def initialize(computer)
    super(computer)

    @steps << -> { @computer.bus.value = @computer.ram[@computer.pc.value].value }
    @steps << -> { @computer.i.value = @computer.bus.value << 0x8 }
    @steps << -> {
      @computer.bus.value = 0
      @computer.pc.value += 1
    }
    @steps << -> { @computer.bus.value = 0x1 }
    @steps << -> {
      @computer.ta.value = @computer.a.value
      @computer.tb.value = @computer.bus.value
    }
    @steps << -> { @computer.bus.value = 0 }
    @steps << -> {
      result = @computer.ta.value + @computer.tb.value
      @computer.bus.value = result
      @computer.c.value = result[4]
      @computer.z.value = result & 0xf == 0 ? 1 : 0
    }
    @steps << -> { @computer.a.value = @computer.bus.value }
    @steps << -> { @computer.bus.value = 0 }
  end
end
