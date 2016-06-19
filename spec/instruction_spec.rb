require 'computer'
require 'instruction'

RSpec.describe Instruction do
  describe 'from_instruction' do
    it 'initializes an instruction from an opcode' do
      computer = Computer.new
      instruction = Instruction.from_opcode(0x0, computer)

      expect(instruction).to be_a(Instruction)
    end
  end
end

RSpec.describe Instruction::NOP do
  it 'increments the program counter' do
    computer = Computer.new
    instruction = Instruction::NOP.new(computer)

    3.times{ instruction.clock! }

    expect(computer.pc.value).to eq(1)
  end
end

RSpec.describe Instruction::JMP do
  it 'changes the value of the program counter' do
    computer = Computer.new
    instruction = Instruction::JMP.new(computer)

    computer.ram[0x000].value = 0x10
    computer.ram[0x001].value = 0x4c

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x04c)
  end
end

RSpec.describe Instruction::JC do
  it 'does not change the value of the program counter if carry is 0' do
    computer = Computer.new
    instruction = Instruction::JC.new(computer)

    computer.ram[0x000].value = 0x20
    computer.ram[0x001].value = 0x4c
    computer.c.value = 0

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x002)
  end

  it 'changes the value of the program counter if carry is 1' do
    computer = Computer.new
    instruction = Instruction::JC.new(computer)

    computer.ram[0x000].value = 0x20
    computer.ram[0x001].value = 0x4c
    computer.c.value = 1

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x04c)
  end
end

RSpec.describe Instruction::JZ do
  it 'does not change the value of the program counter if zero is 0' do
    computer = Computer.new
    instruction = Instruction::JZ.new(computer)

    computer.ram[0x000].value = 0x30
    computer.ram[0x001].value = 0x4c
    computer.z.value = 0

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x002)
  end

  it 'changes the value of the program counter if zero is 1' do
    computer = Computer.new
    instruction = Instruction::JZ.new(computer)

    computer.ram[0x000].value = 0x30
    computer.ram[0x001].value = 0x4c
    computer.z.value = 1

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x04c)
  end
end

RSpec.describe Instruction::CALL do
  it 'changes the value of the program counter' do
    computer = Computer.new
    instruction = Instruction::CALL.new(computer)

    computer.ram[0x000].value = 0x10
    computer.ram[0x001].value = 0x4c

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x04c)
  end

  it 'pushes the last value of the program counter down the stack' do
    computer = Computer.new
    instruction = Instruction::CALL.new(computer)

    computer.ram[0x000].value = 0x10
    computer.ram[0x001].value = 0x4c

    expect(computer.pc.value).to eq(0x0)

    6.times{ instruction.clock! }

    expect(computer.stack[1].value).to eq(0x002)
  end
end

RSpec.describe Instruction::RET do
  it 'changes the program counter to the value down the stack' do
    computer = Computer.new
    instruction = Instruction::RET.new(computer)

    computer.stack[0].value = 0x000
    computer.stack[1].value = 0x04c

    expect(computer.pc.value).to eq(0x0)

    3.times{ instruction.clock! }

    expect(computer.pc.value).to eq(0x04c)
  end
end

RSpec.describe Instruction::LD do
  it 'changes the value of the accumulator' do
    computer = Computer.new
    instruction = Instruction::LD.new(computer)

    computer.r[0x0].value = 0x4
    computer.ram[0x001].value = 0x00

    6.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x4)
  end
end

RSpec.describe Instruction::LDI do
  it 'changes the value of the accumulator' do
    computer = Computer.new
    instruction = Instruction::LDI.new(computer)

    computer.ram[0x001].value = 0x4

    expect(computer.a.value).to eq(0x0)

    9.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x4)
  end
end

RSpec.describe Instruction::LDM do
  it 'changes the value of the accumulator' do
    computer = Computer.new
    instruction = Instruction::LDM.new(computer)

    computer.ram[0x000].value = 0x60
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    expect(computer.a.value).to eq(0x0)

    9.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x4)
  end
end

RSpec.describe Instruction::ST do
  it 'changes the value of the register' do
    computer = Computer.new
    instruction = Instruction::ST.new(computer)

    computer.a.value = 0x4
    computer.ram[0x000].value = 0x70

    6.times{ instruction.clock! }

    expect(computer.r[0x0].value).to eq(0x4)
  end
end

RSpec.describe Instruction::STC do
  it 'sets the carry flag to 1' do
    computer = Computer.new
    instruction = Instruction::STC.new(computer)

    computer.ram[0x000].value = 0x81

    6.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the carry flag to 0' do
    computer = Computer.new
    instruction = Instruction::STC.new(computer)

    computer.c.value = 0
    computer.ram[0x000].value = 0x80

    6.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end
end

RSpec.describe Instruction::STM do
  it 'stores the value of the accumulator' do
    computer = Computer.new
    instruction = Instruction::STM.new(computer)

    computer.ram[0x000].value = 0x90
    computer.ram[0x001].value = 0x4c

    computer.a.value = 0x4

    9.times{ instruction.clock! }

    expect(computer.ram[0x04c].value).to eq(0x4)
  end
end

RSpec.describe Instruction::NOR do
  it 'performs a NOR of a register and accumulator' do
    computer = Computer.new
    instruction = Instruction::NOR.new(computer)

    computer.a.value = "0000000".to_i(2)
    computer.r[0x0].value = "01010101".to_i(2)

    9.times{ instruction.clock! }

    expect(computer.a.to_bin).to eq("10101010")
  end

  it 'sets the zero flag to 1 if the result is 0' do
    computer = Computer.new
    instruction = Instruction::NOR.new(computer)

    computer.a.value = "10101010".to_i(2)
    computer.r[0x0].value = "01010101".to_i(2)

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the result is not 0' do
    computer = Computer.new
    instruction = Instruction::NOR.new(computer)

    computer.a.value = "00000000".to_i(2)
    computer.r[0x0].value = "01010101".to_i(2)

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 0' do
    computer = Computer.new
    instruction = Instruction::NOR.new(computer)

    computer.c.value = 1

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end
end

RSpec.describe Instruction::NORI do
  it 'performs a NOR of a value and accumulator' do
    computer = Computer.new
    instruction = Instruction::NORI.new(computer)

    computer.a.value = "00000000".to_i(2)
    computer.ram[0x001].value = "01010101".to_i(2)

    12.times{ instruction.clock! }

    expect(computer.a.to_bin).to eq("10101010")
  end

  it 'sets the zero flag to 1 if the result is 0' do
    computer = Computer.new
    instruction = Instruction::NORI.new(computer)

    computer.a.value = "10101010".to_i(2)
    computer.ram[0x001].value = "01010101".to_i(2)

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the result is not 0' do
    computer = Computer.new
    instruction = Instruction::NORI.new(computer)

    computer.a.value = "00000000".to_i(2)
    computer.ram[0x001].value = "01010101".to_i(2)

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 0' do
    computer = Computer.new
    instruction = Instruction::NOR.new(computer)

    computer.c.value = 1

    12.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end
end

RSpec.describe Instruction::NORM do
  it 'performs a NOR of the operand and accumulator' do
    computer = Computer.new
    instruction = Instruction::NORM.new(computer)

    computer.a.value = "00000000".to_i(2)

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = "01010101".to_i(2)

    12.times{ instruction.clock! }

    expect(computer.a.to_bin).to eq("10101010")
  end

  it 'sets the zero flag to 1 if the result is 0' do
    computer = Computer.new
    instruction = Instruction::NORM.new(computer)

    computer.a.value = "10101010".to_i(2)

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = "01010101".to_i(2)

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the result is not 0' do
    computer = Computer.new
    instruction = Instruction::NORM.new(computer)

    computer.a.value = "00000000".to_i(2)

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = "01010101".to_i(2)

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 0' do
    computer = Computer.new
    instruction = Instruction::NORM.new(computer)

    computer.c.value = 1

    12.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end
end

RSpec.describe Instruction::ADD do
  it 'adds the register and the accumulator' do
    computer = Computer.new
    instruction = Instruction::ADD.new(computer)

    computer.a.value = 0x4
    computer.r[0x0].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x8)
  end

  it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
    computer = Computer.new
    instruction = Instruction::ADD.new(computer)

    computer.a.value = 0x4
    computer.r[0x0].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end

  it 'sets the carry flag to 1 if the result is larger than 4 bits' do
    computer = Computer.new
    instruction = Instruction::ADD.new(computer)

    computer.a.value = 0xf
    computer.r[0x0].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the result is not 0' do
    computer = Computer.new
    instruction = Instruction::ADD.new(computer)

    computer.a.value = 0x4
    computer.r[0x0].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 1 if the result is 0' do
    computer = Computer.new
    instruction = Instruction::ADD.new(computer)

    computer.a.value = 0xf
    computer.r[0x0].value = 0x1

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end
end

RSpec.describe Instruction::ADDI do
  it 'adds the operand and the accumulator' do
    computer = Computer.new
    instruction = Instruction::ADDI.new(computer)

    computer.a.value = 0x4
    computer.ram[0x001].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x8)
  end

  it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
    computer = Computer.new
    instruction = Instruction::ADDI.new(computer)

    computer.a.value = 0x4
    computer.ram[0x001].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end

  it 'sets the carry flag to 1 if the result is larger than 4 bits' do
    computer = Computer.new
    instruction = Instruction::ADDI.new(computer)

    computer.a.value = 0xf
    computer.ram[0x01].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the result is not 0' do
    computer = Computer.new
    instruction = Instruction::ADDI.new(computer)

    computer.a.value = 0x4
    computer.ram[0x001].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 1 if the result is 0' do
    computer = Computer.new
    instruction = Instruction::ADDI.new(computer)

    computer.a.value = 0xf
    computer.ram[0x001].value = 0x1

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end
end

RSpec.describe Instruction::ADDM do
  it 'adds the operand and the accumulator' do
    computer = Computer.new
    instruction = Instruction::ADDM.new(computer)

    computer.a.value = 0x4

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x8)
  end

  it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
    computer = Computer.new
    instruction = Instruction::ADDM.new(computer)

    computer.a.value = 0x4

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end

  it 'sets the carry flag to 1 if the result is larger than 4 bits' do
    computer = Computer.new
    instruction = Instruction::ADDM.new(computer)

    computer.a.value = 0xf

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the result is not 0' do
    computer = Computer.new
    instruction = Instruction::ADDM.new(computer)

    computer.a.value = 0x4

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 1 if the result is 0' do
    computer = Computer.new
    instruction = Instruction::ADDM.new(computer)

    computer.a.value = 0xf

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x1

    12.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end
end

RSpec.describe Instruction::CMP do
  it 'does not change the accumulator' do
    computer = Computer.new
    instruction = Instruction::CMP.new(computer)

    computer.a.value = 0x4

    6.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x4)
  end

  it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
    computer = Computer.new
    instruction = Instruction::CMP.new(computer)

    computer.a.value = 0x4
    computer.r[0x0].value = 0x4

    6.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end

  it 'sets the carry flag to 1 if the result is larger than 4 bits' do
    computer = Computer.new
    instruction = Instruction::CMP.new(computer)

    computer.a.value = 0x1
    computer.r[0x0].value = 0xf

    6.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the operand and the accumulator are not equal' do
    computer = Computer.new
    instruction = Instruction::CMP.new(computer)

    computer.a.value = 0x4
    computer.r[0x0].value = 0x8

    6.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 1 if the operand and the accumulator are equal' do
    computer = Computer.new
    instruction = Instruction::CMP.new(computer)

    computer.a.value = 0x4
    computer.r[0x0].value = 0x4

    6.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end
end

RSpec.describe Instruction::CMPI do
  it 'does not change the accumulator' do
    computer = Computer.new
    instruction = Instruction::CMPI.new(computer)

    computer.a.value = 0x4

    9.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x4)
  end

  it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
    computer = Computer.new
    instruction = Instruction::CMPI.new(computer)

    computer.a.value = 0x4
    computer.ram[0x001].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end

  it 'sets the carry flag to 1 if the result is larger than 4 bits' do
    computer = Computer.new
    instruction = Instruction::CMPI.new(computer)

    computer.a.value = 0x1
    computer.ram[0x001].value = 0xf

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the operand and the accumulator are not equal' do
    computer = Computer.new
    instruction = Instruction::CMPI.new(computer)

    computer.a.value = 0x4
    computer.ram[0x001].value = 0x8

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 1 if the operand and the accumulator are equal' do
    computer = Computer.new
    instruction = Instruction::CMPI.new(computer)

    computer.a.value = 0x4
    computer.ram[0x001].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end
end

RSpec.describe Instruction::CMPM do
  it 'does not change the accumulator' do
    computer = Computer.new
    instruction = Instruction::CMPM.new(computer)

    computer.a.value = 0x4

    9.times{ instruction.clock! }

    expect(computer.a.value).to eq(0x4)
  end

  it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
    computer = Computer.new
    instruction = Instruction::CMPM.new(computer)

    computer.a.value = 0x4

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(0)
  end

  it 'sets the carry flag to 1 if the result is larger than 4 bits' do
    computer = Computer.new
    instruction = Instruction::CMPM.new(computer)

    computer.a.value = 0x1

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0xf

    9.times{ instruction.clock! }

    expect(computer.c.value).to eq(1)
  end

  it 'sets the zero flag to 0 if the operand and the accumulator are not equal' do
    computer = Computer.new
    instruction = Instruction::CMPM.new(computer)

    computer.a.value = 0x4

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x2

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(0)
  end

  it 'sets the zero flag to 1 if the operand and the accumulator are equal' do
    computer = Computer.new
    instruction = Instruction::CMPM.new(computer)

    computer.a.value = 0x4

    computer.ram[0x000].value = 0x00
    computer.ram[0x001].value = 0x4c

    computer.ram[0x04c].value = 0x4

    9.times{ instruction.clock! }

    expect(computer.z.value).to eq(1)
  end
end
