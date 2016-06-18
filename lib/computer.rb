require 'operation'
require 'register'

class Computer
  attr_reader :accumulator, :buffer, :carry, :input, :instruction_counter, :output, :operation, :program_counter, :ram, :zero

  alias_method :a, :accumulator
  alias_method :b, :buffer
  alias_method :c, :carry
  alias_method :ic, :instruction_counter
  alias_method :in, :input
  alias_method :out, :output
  alias_method :op, :operation
  alias_method :pc, :program_counter
  alias_method :z, :zero

  def initialize
    @accumulator = Register.new(4)
    @buffer = Register.new(4)
    @carry = Register.new(1)
    @input = Array.new(16){ Register.new(4) }
    @instruction_counter = Register.new(3)
    @output = Array.new(16){ Register.new(4) }
    @program_counter = Register.new(12)
    @ram = Array.new(4096){ Register.new(4) }
    @zero = Register.new(1)
    @operations = Array.new(16){ |i| Operation.from_opcode(i, self) }
    @operation = nil
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
      sleep 1.0 / 8 / 2 # two operations per second
    end
  end

  def clock!
    if op.nil? || ic.value == 0x0
      @operation = @operations[ram[pc.value].value]

      print "\n#{pc.to_hex} - #{op.name.ljust(4)} - |"
    end

    op.clock!

    print '#'
    print "|" if ic.value == 0x0

    nil
  end
end
