require 'register'

RSpec.describe Register do
  describe 'new' do
    it 'initializes a 1-bit register' do
      register = Register.new

      expect(register.bits).to eq(1)
    end

    it 'initializes a register of a given number of bits' do
      register = Register.new(bits: 4)

      expect(register.bits).to eq(4)
    end

    it 'initializes a register with default value of 0' do
      register = Register.new

      expect(register.value).to eq(0)
    end

    it 'initializes a register with the given default value' do
      register = Register.new(value: 1)

      expect(register.value).to eq(1)
    end
  end

  describe 'value=' do
    it 'stores a value less than or equal to bits' do
      register = Register.new

      register.value = 1

      expect(register.value).to eq(1)
    end

    it 'does not store a value larger than bits' do
      register = Register.new

      expect{ register.value = 2 }.to raise_exception(StandardError, 'value is larger than register')
    end

    it 'only stores integers' do
      register = Register.new

      expect{ register.value = 'foo' }.to raise_exception(StandardError, 'value is not an integer')
    end
  end

  describe 'bits' do
    it 'returns the size in bits' do
      register = Register.new(bits: 4)

      expect(register.bits).to eq(4)
    end
  end

  describe 'to_hex' do
    it 'returns the value as a hexidecimal string with padding' do
      register = Register.new(bits: 8, value: 0xf)

      expect(register.to_hex).to eq('0x0f')
    end
  end

  describe 'to_bin' do
    it 'returns the value as binary string with padding' do
      register = Register.new(bits: 8, value: 15)

      expect(register.to_bin).to eq('00001111')
    end
  end
end
