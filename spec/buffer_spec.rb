require 'spec_helper'

RSpec.describe Buffer do
  let(:buffer) { Buffer.new(8, 8) }

  describe 'value=' do
    before do
      buffer.value = 3
    end

    it 'should set the value and increment the write pointer' do
      expect(buffer.registers.first.value).to eq(3)
      expect(buffer.write_pointer.value).to eq(1)
    end
  end

  describe 'value' do
    before do
      buffer.value = 3
    end

    it 'should read the value and increment the write pointer' do
      expect(buffer.value).to eq(3)
      expect(buffer.read_pointer.value).to eq(1)
    end

    context 'when reading again' do
      before do
        2.times{ buffer.value }
      end

      it 'should not read past the write pointer' do
        expect(buffer.read_pointer.value).to eq(buffer.write_pointer.value)
      end
    end
  end
end
