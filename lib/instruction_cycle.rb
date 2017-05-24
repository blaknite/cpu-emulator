class InstructionCycle
  attr_reader :counter, :steps

  def initialize
    reset!
  end

  def reset!
    @states = [:fetch, :decode, :execute]
    reset_counter!
    initialize_state!
  end

  def clock!
    switch_state! if steps.empty?
    execute_step! if steps.any?
    increment_counter!
    print! if Computer.debug?
  end

  def state
    @states.first
  end

  private

  def switch_state!
    @states.rotate!
    reset_counter!
    initialize_state!
    switch_state! if steps.empty? && state == :decode
  end

  def initialize_state!
    case state
    when :fetch
      @steps = Transaction.get(:fetch_first_byte)
    when :decode
      @steps = Transaction.get(:fetch_second_byte) if second_byte_required?
    when :execute
      @steps = Instruction.get(opcode)
    end
  end

  def execute_step!
    @steps.shift.call
  end

  def reset_counter!
    @counter = 0
  end

  def increment_counter!
    @counter += 1
  end

  def print!
    output = ''
    output += "#{Computer::STACK.to_hex} - " if counter == 1 && state == :fetch
    output += "|" if counter == 1
    output += '#'
    output += "| - #{opcode.to_s.ljust(4)}\n" if steps.empty? && state == :execute

    print output
  end

  def opcode
    Instruction::OPCODES.keys[Computer::INSTRUCTION.value >> 12]
  end

  def second_byte_required?
    Instruction::OPCODES[opcode] == 2
  end
end
