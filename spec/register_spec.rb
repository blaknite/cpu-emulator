require 'register'

RSpec.describe Register do
  it 'initializes a 1-bit register' do
    register = Register.new

    expect(register.size).to eq(1)
  end

  it 'initializes a register of a given number of bits' do
    register = Register.new(size: 4)

    expect(register.size).to eq(4)
  end

  it 'initializes a register with default value of 0' do
    register = Register.new

    expect(register.value).to eq(0)
  end

  it 'initializes a register with the given default value' do
    register = Register.new(value: 1)

    expect(register.value).to eq(1)
  end

  describe 'value=' do
    it 'stores a value less than or equal to size' do
      register = Register.new

      register.value = 1

      expect(register.value).to eq(1)
    end

    it 'does not store a value larger than size' do
      register = Register.new

      expect{ register.value = 2 }.to raise_exception(StandardError, 'value is larger than size')
    end

    it 'only stores integers' do
      register = Register.new

      expect{ register.value = 'foo' }.to raise_exception(StandardError, 'value is not an integer')
    end
  end

  describe 'value' do
    it 'always returns an integer' do
      register = Register.new

      expect(register.value).to be_a(Integer)
    end
  end

  describe 'to_i' do
    it 'returns the value as an integer' do
      register = Register.new(size: 4, value: 1)

      expect(register.to_i).to eq(1)
    end
  end

  describe 'to_hex' do
    it 'returns the value as hexidecimal' do
      register = Register.new(size: 4, value: 1)

      expect(register.to_hex).to eq('0x0001')
    end
  end

  describe 'to_binary' do
    it 'returns the value as binary' do
      register = Register.new(size: 4, value: 1)

      expect(register.to_binary).to eq('0001')
    end
  end
end
