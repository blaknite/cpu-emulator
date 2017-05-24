require 'definitions'
require 'instruction_cycle'
require 'register'
require 'stack'

module Computer
  A           = Register.new(8)
  B           = Register.new(8)
  BUS         = Register.new(8)
  CARRY       = Register.new(1)
  INSTRUCTION = Register.new(16)
  RAM         = Array.new(4096) { Register.new(8) }
  REGISTER    = Array.new(16)   { Register.new(8) }
  STACK       = Stack.new(12)
  ZERO        = Register.new(1)

  CYCLE = InstructionCycle.new

  def self.debug=(value)
    @debug = value
  end

  def self.debug?
    @debug
  end

  def self.load_program(program)
    reset!
    program.each_with_index do |d, i|
      RAM[i].value = d
    end
    puts "Program loaded!" if Computer.debug?
  end

  def self.load_file(file)
    load_program(File.open(file, 'r').read.unpack('C*'))
  end

  def self.reset!
    A.value = 0
    B.value = 0
    BUS.value = 0
    CARRY.value = 0
    INSTRUCTION.value = 0
    ZERO.value = 0
    RAM.each{ |r| r.value = 0 }
    REGISTER.each{ |r| r.value = 0 }
    STACK.reset!
    CYCLE.reset!
  end

  def self.run!
    puts "Running..." if Computer.debug?

    while true do
      clock!
      sleep 1.0 / 30 # 30Hz
    end
  end

  def self.clock!
    CYCLE.clock!
  end
end
