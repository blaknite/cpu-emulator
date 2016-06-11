class Value
  attr_reader :value

  def initialize(value:)
    self.value = value
  end

  def value=(new_value)
    fail 'value is not an integer' unless new_value.is_a?(Integer)
    @value = new_value
  end

  def bits
    Math.log2(value).to_i + 1
  end

  def to_int
    value
  end

  alias_method :to_i, :to_int

  def to_s(base = 10)
    value.to_s(base)
  end

  def to_hex
    '0x' + self.to_s(16).rjust(bits / 4, "0")
  end

  def to_bin
    self.to_s(2).rjust(bits, "0")
  end
end
