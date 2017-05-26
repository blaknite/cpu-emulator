class Stack
  attr_accessor :bits, :depth, :pointer, :registers

  def initialize(bits, depth)
    @bits = bits
    @depth = depth
    @pointer = Register.new(depth)
    @registers = Array.new(4) { Register.new(bits) }
  end

  def value=(value)
    current_register.value = value
  end

  def value
    current_register.value
  end

  alias_method :to_int, :value
  alias_method :to_i, :value

  def to_s(base = 10)
    current_register.to_s(base)
  end

  def to_hex
    current_register.to_hex
  end

  def to_bin
    current_register.to_bin
  end

  def reset!
    pointer.value = 0
    registers.each { |r| r.value = 0 }
  end

  private

  def current_register
    registers[pointer.value]
  end
end
