require 'instruction'

RSpec.describe Instruction do
  describe 'new' do
    it 'initializes an empty instruction' do
      instruction = Instruction.new

      expect(instruction.get).to eq(0)
    end
  end

  describe 'opcode' do
    it 'returns the current opcode in decimal' do
      instruction = Instruction.new(value: '11110000'.to_i(2))

      expect(instruction.opcode).to eq('1111'.to_i(2))
    end
  end

  describe 'operand' do
    it 'returns the current operand as an instance of Value' do
      instruction = Instruction.new(value: '11110000'.to_i(2))

      expect(instruction.operand).to be_a(Value)
      expect(instruction.operand.get).to eq(0x0)
    end
  end

  describe 'set' do
    it 'is a private method' do
      instruction = Instruction.new

      expect{ instruction.set(0xff) }.to raise_error(NoMethodError)
    end
  end
end
