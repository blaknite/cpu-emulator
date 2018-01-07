class Buffer
  attr_accessor :bits, :size, :read_pointer, :write_pointer, :registers

  def initialize(bits, size)
    @bits = bits
    @size = size
    bit_length = (size - 1).bit_length
    @read_pointer = Register.new(bit_length)
    @write_pointer = Register.new(bit_length)
    @registers = Array.new(size) { Register.new(bits) }
  end

  def value=(value)
    current_write_register.value = value
    write_pointer.value += 1
  end

  def value
    value = current_read_register.value
    read_pointer.value += 1 unless empty?
    value
  end

  def empty?
    write_pointer.value == read_pointer.value
  end

  def reset!
    read_pointer.reset!
    write_pointer.reset!
    registers.each(&:reset!)
  end

  private

  def current_read_register
    registers[read_pointer.value]
  end

  def current_write_register
    registers[write_pointer.value]
  end
end
