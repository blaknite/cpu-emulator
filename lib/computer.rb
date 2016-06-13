require 'operation'
require 'register'

class Computer
  attr_reader :accumulator, :carry, :input, :output, :operation, :program_counter, :ram, :zero

  alias_method :a, :accumulator
  alias_method :c, :carry
  alias_method :in, :input
  alias_method :out, :output
  alias_method :op, :operation
  alias_method :pc, :program_counter
  alias_method :z, :zero

  def initialize
    @accumulator = Register.new(4)
    @carry = Register.new(1)
    @input = []
    @output = []
    16.times do
      @input << Register.new(4)
      @output << Register.new(4)
    end
    @program_counter = Register.new(12)
    @ram = []
    4096.times{ @ram << Register.new(4) }
    @zero = Register.new(1)
    @operation = nil
  end

  def load_program(program_data)
    program_data.split(' ').each_with_index do |pd, i|
      @ram[i].value = pd.to_i(16)
    end
  end

  def run
    print 'Running...'

    while true do
      clock
      sleep 1.0 / 8
    end
  end

  def clock
    if op.nil? || op.complete?
      @operation = Operation.from_opcode(ram[pc.value].value, self)

      print "\n#{pc.to_hex} - #{op.name} - |"
    end

    op.clock

    print '#'
    print "|" if op.complete?

    nil
  end
end
