##
# Represntation of a data register
#
# Can be of any number of bits.
# Only accepts integers whose binary representation is less or equal the register's bit length.
class Register
  attr_reader :bits, :value

  def initialize(bits, value = 0)
    @bits = bits
    self.value = value
  end

  def value=(value)
    fail 'value is not an integer' unless value.is_a?(Integer)
    @value = value & ( 2**bits - 1 )
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
    bits.downto(1).map{ |bit| value[bit - 1].to_s }.join
  end

  def reset!
    self.value = 0
  end
end
