require 'instruction'

RSpec.describe Instruction do
  describe 'new' do
    it 'initializes an instruction from the given value' do
      instruction = Instruction.new(0xf4)

      expect(instruction.get).to eq(0xf4)
    end
  end

  describe 'opcode' do
    it 'returns the current opcode as an integer' do
      instruction = Instruction.new(0xf4)

      expect(instruction.opcode).to eq(0xf)
    end
  end

  describe 'operand' do
    it 'returns the current operand as an instance of Value' do
      instruction = Instruction.new(0xf4)

      expect(instruction.operand).to be_a(Value)
      expect(instruction.operand.get).to eq(0x4)
    end
  end

  describe 'set' do
    it 'is a private method' do
      instruction = Instruction.new(0xf4)

      expect{ instruction.set(0xf4) }.to raise_error(NoMethodError)
    end
  end
end
