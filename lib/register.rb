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

  def set(new_value)
    fail 'value is not an integer' unless new_value.is_a?(Integer)
    replace(new_value.to_s(2).chars.last(bits).map(&:to_i))
    unshift(0) until length >= bits
  end

  def bits
    @bits
  end
end
