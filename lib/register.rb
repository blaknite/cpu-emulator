require 'value'

##
# Represntation of a data register
#
# Can be of any number of bits.
# Only accepts integers whose binary representation is less or equal the register's bit length.
class Register < Value
  def initialize(bits: 1, value: 0)
    @bits = bits
    super(value)
  end

  def value=(new_value)
    raise StandardError, 'value is not an integer' unless new_value.is_a?(Integer)
    raise StandardError, 'value is larger than register' if new_value.to_s(2).length > bits
    @value = new_value
  end

  def bits
    @bits
  end

  def to_hex
    '0x' + self.to_s(16).rjust(bits, "0")
  end

  def to_bin
    super.rjust(bits, "0")
  end
end
