require 'spec_helper'

RSpec.describe Register do
  describe 'new' do
    let(:register) { Register.new(4) }

    it 'should be a 4-bit register' do
      expect(register.bits).to eq(4)
    end

    it 'should have a default value of 0' do
      expect(register.value).to eq(0)
    end

    context 'when a default value is provided' do
      let(:register) { Register.new(4, 1) }

      it 'initializes a register with the given initial value' do
        expect(register.value).to eq(1)
      end
    end
  end

  describe 'value=' do
    let(:register) { Register.new(4) }

    it 'only stores integers' do
      expect{ register.value = 'foo' }.to raise_error(StandardError, 'value is not an integer')
    end

    it 'only stores the first n bits' do
      register.value = 0xff
      expect(register.value).to eq(0xf)
    end

    it 'stores a value less <= n bits' do
      register.value = 0xff
      expect(register.value).to eq(0xf)
    end
  end

  describe 'value' do
    let(:register) { Register.new(4, 0xa) }

    it 'returns an integer' do
      expect(register.value).to eq(0xa)
    end
  end

  describe 'bits' do
    let(:register) { Register.new(4) }

    it 'returns the size in bits' do
      expect(register.bits).to eq(4)
    end
  end

  describe 'to_s' do
    let(:register) { Register.new(4, 0xa) }

    it 'returns value as a decimal string' do
      expect(register.to_s).to eq('10')
    end
  end

  describe 'to_int' do
    let(:register) { Register.new(4, 0xa) }

    it 'returns value as an integer' do
      expect(register.to_int).to eq(0xa)
    end
  end

  describe 'to_hex' do
    let(:register) { Register.new(4, 0xa) }

    it 'returns the value as a hexidecimal string' do
      expect(register.to_hex).to eq('0xa')
    end
  end

  describe 'to_bin' do
    let(:register) { Register.new(4, 0xa) }

    it 'returns the value as binary string' do
      expect(register.to_bin).to eq('1010')
    end
  end
end
