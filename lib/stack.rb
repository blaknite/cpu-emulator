class Stack
  attr_accessor :bits, :registers

  def initialize(bits)
    @bits = bits
    @registers = Array.new(4) { Register.new(bits) }
  end

  def value=(value)
    registers.last.value = value
  end

  def value
    registers.last.value
  end

  def to_int
    registers.last.to_int
  end

  alias_method :to_int, :value
  alias_method :to_i, :value

  def to_s(base = 10)
    registers.last.to_s(base)
  end

  def to_hex
    registers.last.to_hex
  end

  def to_bin
    registers.last.to_bin
  end

  def push(value)
    registers.shift
    registers.push(Register.new(bits))
    self.value = value
  end

  def pop
    registers.pop
    registers.unshift(Register.new(bits))
  end

  def reset!
    registers.each { |r| r.value = 0 }
  end
end
