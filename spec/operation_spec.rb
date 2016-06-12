require 'computer'
require 'instruction'
require 'operation'

RSpec.describe Operation do
  describe 'from_instruction' do
    it 'initializes an operation from an instruction' do
      computer = Computer.new
      instruction = Instruction.new(0xf4)
      operation = Operation.from_instruction(computer, instruction)

      expect(operation).to be_a(Operation)
    end
  end

  describe 'perform' do
    it 'increments the program counter' do
      computer = Computer.new
      operation = Operation::NOP.new(computer, 0xf)
      operation.perform

      expect(computer.pc.get).to eq(1)
    end
  end
end

RSpec.describe Operation::NOP do
  describe 'perform' do
    it 'does nothing' do
      computer = Computer.new
      operation = Operation::NOP.new(computer, 0xf)
      operation.perform

      expect_any_instance_of(Register).not_to receive(:set)
    end
  end
end

RSpec.describe Operation::STC do
  describe 'perform' do
    it 'sets the carry flag to 1' do
      computer = Computer.new
      operation = Operation::STC.new(computer, 1)
      operation.perform

      expect(computer.c.get).to eq(1)
    end

    it 'sets the carry flag to 0' do
      computer = Computer.new
      operation = Operation::STC.new(computer, 0)
      operation.perform

      expect(computer.c.get).to eq(0)
    end
  end
end
