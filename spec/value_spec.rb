require 'value'

RSpec.describe Value do
  it 'initializes a value with the given default value' do
    value = Value.new(1)

    expect(value.value).to eq(1)
  end

  describe 'value=' do
    it 'assigns a new value' do
      value = Value.new(1)

      value.value = 2

      expect(value.value).to eq(2)
    end

    it 'only stores integers' do
      value = Value.new(1)

      expect{ value.value = 'foo' }.to raise_exception(StandardError, 'value is not an integer')
    end
  end

  describe 'value' do
    it 'returns a decimal integer' do
      value = Value.new(11)

      expect(value.value).to eq(11)
    end
  end

  describe 'bits' do
    it 'returns the size in bits' do
      register = Value.new(13)

      expect(register.bits).to eq(4)
    end
  end

  describe 'to_int' do
    it 'returns value as a decimal integer' do
      value = Value.new(11)

      expect(value.to_int).to eq(11)
    end
  end

  describe 'to_hex' do
    it 'returns value as hexidecimal string' do
      value = Value.new(1)

      expect(value.to_hex).to eq('0x1')
    end
  end

  describe 'to_bin' do
    it 'returns value as binary string' do
      value = Value.new(1)

      expect(value.to_bin).to eq('1')
    end
  end

  describe 'to_s' do
    it 'returns value as a decimal string' do
      value = Value.new(11)

      expect(value.to_s).to eq('11')
    end
  end
end
