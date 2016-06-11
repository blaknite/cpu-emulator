require 'value'

##
# Represntation of a data register
#
# Can be of any number of bits.
# Only accepts integers whose binary representation is less or equal the register's bit length.
class Register < Value
  def initialize(bits: 1, value: 0)
    @bits = bits
    super(value: value)
  end

  def value=(new_value)
    fail 'value is not an integer' unless new_value.is_a?(Integer)
    fail 'value is larger than register' if new_value >= 2 ** bits
    @value = new_value
  end

  def bits
    @bits
  end
end
