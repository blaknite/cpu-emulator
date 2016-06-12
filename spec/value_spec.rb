require 'value'

RSpec.describe Value do
  describe 'new' do
    it 'initializes a value with the given default value' do
      value = Value.new(0x1)

      expect(value.get).to eq(0x1)
    end
  end

  describe 'set' do
    it 'sets the value to a new value' do
      value = Value.new(0x1)

      value.set(2)

      expect(value.get).to eq(2)
    end

    it 'only stores integers' do
      value = Value.new(0x1)

      expect{ value.set('foo') }.to raise_exception(StandardError, 'value is not an integer')
    end
  end

  describe 'get' do
    it 'returns an integer' do
      value = Value.new(0xa)

      expect(value.get).to eq(0xa)
    end
  end

  describe 'bits' do
    it 'returns the size in bits' do
      register = Value.new(0xf)

      expect(register.bits).to eq(4)
    end
  end

  describe 'to_int' do
    it 'returns value as an integer' do
      value = Value.new(0xa)

      expect(value.to_int).to eq(0xa)
    end
  end

  describe 'to_hex' do
    it 'returns value as hexidecimal string' do
      value = Value.new(0xa)

      expect(value.to_hex).to eq('0xa')
    end
  end

  describe 'to_bin' do
    it 'returns value as binary string' do
      value = Value.new(0xa)

      expect(value.to_bin).to eq('1010')
    end
  end

  describe 'to_s' do
    it 'returns value as a decimal string' do
      value = Value.new(0xa)

      expect(value.to_s).to eq('10')
    end
  end
end
