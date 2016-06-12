require 'register'

RSpec.describe Register do
  describe 'new' do
    it 'initializes a 4-bit register' do
      register = Register.new(4)

      expect(register.bits).to eq(4)
    end

    it 'initializes a register with default value of 0' do
      register = Register.new(1)

      expect(register.get).to eq(0)
    end

    it 'initializes a register with the given initial value' do
      register = Register.new(1, 1)

      expect(register.get).to eq(1)
    end
  end

  describe 'set' do
    it 'only stores integers' do
      register = Register.new(1)

      expect{ register.set('foo') }.to raise_exception(StandardError, 'value is not an integer')
    end

    it 'only stores the first n bits' do
      register = Register.new(4)

      register.set(0xff)

      expect(register.get).to eq(0xf)
    end

    it 'stores a value less <= n bits' do
      register = Register.new(1)

      register.set(0xf)

      expect(register.get).to eq(0x1)
    end
  end

  describe 'bits' do
    it 'returns the size in bits' do
      register = Register.new(4)

      expect(register.bits).to eq(4)
    end
  end

  describe 'to_hex' do
    it 'returns the value as a hexidecimal string with padding' do
      register = Register.new(8, 0xf)

      expect(register.to_hex).to eq('0x0f')
    end
  end

  describe 'to_bin' do
    it 'returns the value as binary string with padding' do
      register = Register.new(8, 0xf)

      expect(register.to_bin).to eq('00001111')
    end
  end
end
