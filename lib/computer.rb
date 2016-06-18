require 'instruction'
require 'register'

class Computer
  attr_reader :accumulator, :bus, :carry, :input, :instruction_counter, :output, :program_counter, :ram, :registers, :temp_a, :temp_b, :zero

  alias_method :a, :accumulator
  alias_method :c, :carry
  alias_method :ic, :instruction_counter
  alias_method :in, :input
  alias_method :out, :output
  alias_method :pc, :program_counter
  alias_method :r, :registers
  alias_method :ta, :temp_a
  alias_method :tb, :temp_b
  alias_method :z, :zero

  def initialize
    @accumulator = Register.new(4)
    @bus = Register.new(4)
    @carry = Register.new(1)
    @instruction_counter = Register.new(4)
    @program_counter = Register.new(12)
    @ram = Array.new(4096){ Register.new(4) }
    @registers = Array.new(16){ Register.new(4) }
    @temp_a = Register.new(4)
    @temp_b = Register.new(4)
    @zero = Register.new(1)
    @instructions = Array.new(16){ |i| Instruction.from_opcode(i, self) }
    @instruction = nil
  end

  def load_program(program_data)
    program_data.split(' ').each_with_index do |pd, i|
      @ram[i].value = pd.to_i(16)
    end
  end

  def run!
    print 'Running...'

    while true do
      clock!
      sleep 1.0 / 8 / 2 # two instructions per second
    end
  end

  def clock!
    if @instruction.nil? || @instruction_counter.value == 0x0
      @instruction = @instructions[@ram[@program_counter.value].value]

      print "\n#{@program_counter.to_hex} - #{@instruction.name.ljust(4)} - |"
    end

    @instruction.clock!

    print '#'
    print "|" if @instruction_counter.value == 0x0

    nil
  end
end
