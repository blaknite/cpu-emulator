require 'computer'
require 'operation'

RSpec.describe Operation do
  describe 'from_instruction' do
    it 'initializes an operation from an opcode' do
      computer = Computer.new
      operation = Operation.from_opcode(0x0, computer)

      expect(operation).to be_a(Operation)
    end
  end
end

RSpec.describe Operation::NOP do
  describe 'clock' do
    it 'increments the program counter' do
      computer = Computer.new
      operation = Operation::NOP.new(computer)
      operation.clock

      expect(computer.pc.get).to eq(1)
    end
  end

  describe 'complete?' do
    it 'returns false unless all steps are complete' do
      computer = Computer.new
      operation = Operation::NOP.new(computer)

      expect(operation.complete?).to eq(false)
    end

    it 'returns true when all steps are complete' do
      computer = Computer.new
      operation = Operation::NOP.new(computer)
      operation.clock

      expect(operation.complete?).to eq(true)
    end
  end
end

RSpec.describe Operation::JMP do
  it 'changes the value of the program counter' do
    computer = Computer.new
    operation = Operation::JMP.new(computer)

    computer.ram[1].set(0x0)
    computer.ram[2].set(0x4)
    computer.ram[3].set(0xc)

    expect(computer.pc.get).to eq(0x0)

    operation.clock until operation.complete?

    expect(computer.pc.get).to eq(0x04c)
  end
end

RSpec.describe Operation::LDI do
  describe 'perform' do
    it 'changes the value of the accumulator' do
      computer = Computer.new
      operation = Operation::LDI.new(computer)

      computer.ram[1].set(0x4)

      expect(computer.a.get).to eq(0x0)

      operation.clock until operation.complete?

      expect(computer.a.get).to eq(0x4)
    end
  end
end

RSpec.describe Operation::STC do
  describe 'perform' do
    it 'sets the carry flag to 1' do
      computer = Computer.new
      operation = Operation::STC.new(computer)

      computer.ram[1].set(1)

      operation.clock until operation.complete?

      expect(computer.c.get).to eq(1)
    end

    it 'sets the carry flag to 0' do
      computer = Computer.new
      operation = Operation::STC.new(computer)

      computer.c.set(0)
      computer.ram[1].set(0)

      operation.clock until operation.complete?

      expect(computer.c.get).to eq(0)
    end
  end
end

RSpec.describe Operation::ADDI do
  describe 'perform' do
    it 'adds the operand and the accumulator' do
      computer = Computer.new
      operation = Operation::ADDI.new(computer)

      computer.a.set(0x4)
      computer.ram[1].set(0x4)

      operation.clock until operation.complete?

      expect(computer.a.get).to eq(0x8)
    end

    it 'sets the carry flag to 0 if the result is smaller than 4 bits' do
      computer = Computer.new
      operation = Operation::ADDI.new(computer)

      computer.a.set(0x4)
      computer.ram[1].set(0x4)

      operation.clock until operation.complete?

      expect(computer.c.get).to eq(0)
    end

    it 'sets the carry flag to 1 if the result is larger than 4 bits' do
      computer = Computer.new
      operation = Operation::ADDI.new(computer)

      computer.a.set(0xf)
      computer.ram[1].set(0x4)

      operation.clock until operation.complete?

      expect(computer.c.get).to eq(1)
    end
  end
end
