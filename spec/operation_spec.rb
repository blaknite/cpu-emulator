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
end

RSpec.describe Operation::NOP do
  describe 'perform' do
    it 'does nothing' do
      computer = Computer.new
      instruction = Instruction.new(0xf4)
      operation = Operation.from_instruction(computer, instruction)

      expect(operation.perform).to eq(nil)
    end
  end
end
