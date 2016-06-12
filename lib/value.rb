class Value < Array
  def initialize(value:)
    set(value)
  end

  def set(new_value)
    fail 'value is not an integer' unless new_value.is_a?(Integer)
    replace(new_value.to_s(2).chars.map(&:to_i))
  end

  def get
    join.to_i(2)
  end

  def bits
    length
  end

  def to_int
    get
  end

  alias_method :to_i, :to_int

  def to_s(base = 10)
    get.to_s(base)
  end

  def to_hex
    '0x' + to_s(16).rjust(bits / 4, "0")
  end

  def to_bin
    to_s(2).rjust(bits, "0")
  end
end
