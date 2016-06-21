require 'instruction'
require 'register'

class Computer
  attr_reader :accumulator, :bus, :carry, :instruction_counter, :instruction_register, :ram, :registers, :stack, :temp_a, :temp_b, :zero

  alias_method :a, :accumulator
  alias_method :c, :carry
  alias_method :ic, :instruction_counter
  alias_method :i, :instruction_register
  alias_method :r, :registers
  alias_method :ta, :temp_a
  alias_method :tb, :temp_b
  alias_method :z, :zero

  def initialize
    @accumulator = Register.new(8)
    @bus = Register.new(8)
    @carry = Register.new(1)
    @instruction_counter = Register.new(5)
    @instruction_register = Register.new(16)
    @ram = Array.new(2**12){ Register.new(8) }
    (0xff0..0xff7).each{ |n| @ram[n] = InputRegister.new }
    (0xff8..0xfff).each{ |n| @ram[n] = OutputRegister.new }
    @registers = Array.new(16){ Register.new(8) }
    @stack = Array.new(4){ Register.new(12) }
    @temp_a = Register.new(8)
    @temp_b = Register.new(8)
    @zero = Register.new(1)
    @instructions = Array.new(16){ |i| Instruction.from_opcode(i, self) }
    @instruction = nil
  end

  def program_counter
    @stack.first
  end

  alias_method :pc, :program_counter

  def load_program(program_data)
    program_data.each_with_index do |pd, i|
      @ram[i].value = pd
    end
  end

  def run!
    print 'Running...'

    while true do
      clock!
      sleep 1.0 / 30 # 60Hz
    end
  end

  def clock!
    if @instruction.nil? || @instruction_counter.value == 0x0
      @instruction = @instructions[(@ram[program_counter.value].value & 0xf0) >> 4]

      print "\n#{program_counter.to_hex} - #{@instruction.name.ljust(4)} - |"
    end

    @instruction.clock!

    print '#'
    print "|" if @instruction_counter.value == 0x0

    nil
  end
end
