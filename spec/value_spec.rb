require 'value'

RSpec.describe Value do
  describe 'new' do
    it 'initializes a value with the given default value' do
      value = Value.new(value: 1)

      expect(value.get).to eq(1)
    end
  end

  describe 'set' do
    it 'sets the value to a new value' do
      value = Value.new(value: 1)

      value.set(2)

      expect(value.get).to eq(2)
    end

    it 'only stores integers' do
      value = Value.new(value: 1)

      expect{ value.set('foo') }.to raise_exception(StandardError, 'value is not an integer')
    end
  end

  describe 'get' do
    it 'returns a decimal integer' do
      value = Value.new(value: 11)

      expect(value.get).to eq(11)
    end
  end

  describe 'bits' do
    it 'returns the size in bits' do
      register = Value.new(value: 13)

      expect(register.bits).to eq(4)
    end
  end

  describe 'to_int' do
    it 'returns value as a decimal integer' do
      value = Value.new(value: 11)

      expect(value.to_int).to eq(11)
    end
  end

  describe 'to_hex' do
    it 'returns value as hexidecimal string' do
      value = Value.new(value: 1)

      expect(value.to_hex).to eq('0x1')
    end
  end

  describe 'to_bin' do
    it 'returns value as binary string' do
      value = Value.new(value: 1)

      expect(value.to_bin).to eq('1')
    end
  end

  describe 'to_s' do
    it 'returns value as a decimal string' do
      value = Value.new(value: 11)

      expect(value.to_s).to eq('11')
    end
  end
end
