class Stack
  attr_accessor :bits, :depth, :pointer, :registers

  def initialize(bits, depth)
    @bits = bits
    @depth = depth
    bit_length = (depth - 1).bit_length
    @pointer = Register.new(bit_length)
    @registers = Array.new(depth) { Register.new(bits) }
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
    pointer.reset!
    registers.each(&:reset!)
  end

  private

  def current_register
    registers[pointer.value]
  end
end
