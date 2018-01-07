require 'definitions'
require 'instruction_cycle'
require 'register'
require 'stack'
require 'terminal'
require 'buffer'

module Computer
  A             = Register.new(8)
  B             = Register.new(8)
  BUS           = Register.new(8)
  CARRY         = Register.new(1)
  INSTRUCTION   = Register.new(16)
  RAM           = Array.new(4096) { Register.new(8) }
  REGISTER      = Array.new(14)   { Register.new(8) }
  REGISTER[0xe] = Buffer.new(8, 8)
  REGISTER[0xf] = Buffer.new(8, 8)
  STACK         = Stack.new(12, 4)
  ZERO          = Register.new(1)

  CYCLE = InstructionCycle.new

  FREQUENCY = 60 # Hz

  TERMINAL = Terminal.new

  LOG_FILE = File.open(File.join(File.dirname(__FILE__), '..', 'tmp', 'debug.log'), 'w')

  def self.debug=(value)
    @debug = value
  end

  def self.debug?
    @debug
  end

  def self.log(message)
    return unless Computer.debug?
    LOG_FILE.print(message)
    LOG_FILE.flush
  end

  def self.load_program(program)
    reset!
    program.each_with_index do |d, i|
      RAM[i].value = d
    end
    puts "Program loaded!"
    log "Program loaded!\n"
  end

  def self.load_file(file)
    load_program(File.open(file, 'r').read.unpack('C*'))
  end

  def self.reset!
    A.reset!
    B.reset!
    BUS.reset!
    CARRY.reset!
    INSTRUCTION.reset!
    ZERO.reset!
    RAM.each(&:reset!)
    REGISTER.each(&:reset!)
    STACK.reset!
    CYCLE.reset!
  end

  def self.run!
    TERMINAL.init

    puts "Running..."
    log "Running...\n"

    run_computer!
    run_terminal!
  ensure
    TERMINAL.close
  end

  def self.run_computer!
    Thread.start do
      while true
        CYCLE.clock!
        wait
      end
    end
  end

  def self.run_terminal!
    while true
      TERMINAL.clock!
      wait
    end
  end

  def self.wait
    sleep 1.0 / FREQUENCY
  end
end
