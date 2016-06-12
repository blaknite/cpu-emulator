require 'instruction'
require 'operation'

RSpec.describe Operation do
  describe 'from_instruction' do
    it 'initializes an operation from an instruction' do
      instruction = Instruction.new(0xf4)
      operation = Operation.from_instruction(instruction)

      expect(operation).to be_a(Operation)
    end
  end
end

RSpec.describe Operation::NOP do
  describe 'perform' do
    it 'does nothing' do
      operation = Operation::NOP.new(0xf)

      expect(operation.perform).to eq(nil)
    end
  end
end
