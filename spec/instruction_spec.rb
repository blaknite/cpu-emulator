require 'spec_helper'

RSpec.describe Instruction do
  before do
    Transaction.clear!
  end

  context 'when defining an instruction' do
    context 'when the instruction is valid' do
      it 'should define the instruction' do
        expect{ Instruction.define(:JMP) {} }.not_to raise_error
      end
    end

    context 'when the instruction is invalid' do
      it 'should define the instruction' do
        expect{ Instruction.define(:test) {} }.to raise_error(StandardError, 'invalid instruction: test')
      end
    end
  end

  context 'when getting an instruction' do
    before do
      Transaction.define :test do
        define_step -> {}
      end

      Instruction.define :JMP do
        define_step -> {}
      end
    end

    context 'when the instruction is valid' do
      it 'gets the instruction' do
        expect(Instruction.get(:JMP)).to be_a Array
        expect(Instruction.get(:JMP).length).to eq 1
        expect(Instruction.get(:JMP).first).to be_a Proc
      end
    end

    context 'when the instruction is invalid' do
      it 'throws an error' do
        expect{ Instruction.get(:test) }.to raise_error(StandardError, 'invalid instruction: test')
      end
    end
  end
end
