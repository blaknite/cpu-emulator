require 'spec_helper'

RSpec.describe InstructionCycle do
  let(:instruction_cycle) { InstructionCycle.new }

  describe '#reset!' do
    before do
      5.times { instruction_cycle.clock! }
      instruction_cycle.reset!
    end

    it 'should reset the state' do
      expect(instruction_cycle.state).to eq :fetch
    end

    it 'should reset the counter' do
      expect(instruction_cycle.counter).to eq 0
    end
  end

  describe '#clock!' do
    before do
      1.times { instruction_cycle.clock! }
    end

    it 'increment the counter' do
      expect(instruction_cycle.counter).to eq 1
    end

    it 'should load a transaction' do
      expect(instruction_cycle.steps).not_to be_empty
    end
  end
end
