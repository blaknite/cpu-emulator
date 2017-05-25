require 'spec_helper'

RSpec.describe Stack do
  let(:stack) { Stack.new(12, 2) }

  before do
    stack.registers.each.with_index do |r, i|
      r.value = i
    end
  end

  describe '#value' do
    it 'should return the current value' do
      expect(stack.value).to eq 0
    end

    context 'when the pointer is incremented' do
      before do
        stack.pointer.value += 1
      end

      it 'should return the current value' do
        expect(stack.value).to eq 1
      end
    end
  end

  describe '#value=' do
    before do
      stack.value = 1
    end

    it 'should set the value' do
      expect(stack.value).to eq 1
    end
  end
end
