##
# Represntation of a data register
#
# Can be of any size.
# Only accepts integers whose binary representation is less or equal the register's size.
class Register
  attr_reader :size, :value

  def initialize(size: 1, value: 0)
    @size = size
    self.value = value
  end

  def value=(value)
    raise StandardError, 'value is not an integer' unless value.is_a?(Integer)
    raise StandardError, 'value is larger than size' if value.to_s(2).length > size
    @value = value
  end

  def to_i
    value
  end

  def to_hex
    '0x' + value.to_s(16).rjust(size, "0")
  end

  def to_binary
    value.to_s(2).rjust(size, "0")
  end
end
