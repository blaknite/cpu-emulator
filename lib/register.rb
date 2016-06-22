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
  attr_accessor :filename

  def initialize(address = nil, value = 0)
    @filename = "tmp/output#{'_' + address.to_s(16) if address}.txt"
    File.open(@filename, 'w'){ |f| f << nil }
    @bits = 8
    replace((@bits - 1).downto(0).map{ |n| value[n] })
  end

  def value=(new_value)
    super(new_value)
    File.open(@filename, 'a'){ |f| f << [new_value].pack('C*') }
  end
end

class InputRegister < Register
  attr_accessor :filename

  def initialize(address = nil, value = 0)
    @filename = "tmp/input#{'_' + address.to_s(16) if address}.txt"
    @file = File.open(@filename, 'w+')
    @file.write(nil)
    super(8, value)
  end

  def value
    @file.getbyte || 0x00
  end
end
