require 'spec_helper'

RSpec.describe InstructionCycle do
  let(:instruction_cycle) { InstructionCycle.new }
  let(:current_state) { instruction_cycle.send(:current_state) }

  describe '#reset!' do
    before do
      5.times { instruction_cycle.clock! }
      instruction_cycle.reset!
    end

    it 'should reset the state' do
      expect(current_state).to be_a InstructionCycle::Fetch
    end

    it 'should reset the counter' do
      expect(current_state.counter).to eq 0
    end
  end

  describe '#clock!' do
    before do
      1.times { instruction_cycle.clock! }
    end

    it 'increment the counter' do
      expect(current_state.counter).to eq 1
    end

    it 'should load a transaction' do
      expect(current_state.steps).not_to be_empty
    end
  end
end
