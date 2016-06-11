require 'instruction'

RSpec.describe Instruction do
  describe 'new' do
    it 'initializes an empty instruction' do
      instruction = Instruction.new

      expect(instruction.value).to eq(0)
    end

    it 'cannot set a value larger than 8 bits' do
      expect{ Instruction.new(value: 0xfff) }.to raise_error(StandardError, 'value is larger than 8 bits')
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
    end
  end

  describe 'value=' do
    it 'is a private method' do
      instruction = Instruction.new

      expect{ instruction.value = 123 }.to raise_error(NoMethodError)
    end
  end
end
