##
# Represntation of a data register
#
# Can be of any number of bits.
# Only accepts integers whose binary representation is less or equal the register's bit length.
class Register < Array
  attr_reader :bits

  def initialize(bits, value = 0)
    @bits = bits
    self.value = value
  end

  def value=(new_value)
    fail 'value is not an integer' unless new_value.is_a?(Integer)
    replace((@bits - 1).downto(0).map{ |n| new_value[n] })
  end

  def value
    join.to_i(2)
  end

  alias_method :to_int, :value
  alias_method :to_i, :value

  def to_s(base = 10)
    value.to_s(base)
  end

  def to_hex
    '0x' + to_s(16).rjust(bits / 4, "0")
  end

  def to_bin
    join.rjust(bits, "0")
  end
end

class OutputRegister < Register
  attr_accessor :file

  def initialize(address = nil, value = 0)
    @file = "output#{'_' + address.to_s(16) if address}.txt"
    @bits = 8
    File.open(@file, 'w') do |f|
      f << nil
    end
    replace((@bits - 1).downto(0).map{ |n| value[n] })
  end

  def value=(new_value)
    super(new_value)
    File.open(@file, 'a') do |f|
      f << [value].pack('C*')
    end
  end
end

class InputRegister < Register
  attr_accessor :file

  def initialize(address = nil, value = 0)
    @file = "input#{'_' + address.to_s(16) if address}.txt"
    @char_index = 0
    File.open(@file, 'w') do |f|
      f << nil
    end
    super(8, value)
  end

  def value
    char = File.open(@file, 'r').read.unpack('C*')[@char_index]

    @char_index += 1 if char
    char || 0x00
  end
end
