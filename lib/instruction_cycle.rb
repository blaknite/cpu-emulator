class InstructionCycle
  attr_reader :states, :steps

  def initialize
    reset!
  end

  def reset!
    @states = [:fetch_first_byte, :fetch_second_byte, :execute_instruction]
    load_steps!
  end

  def clock!
    switch_state! while steps.empty?
    steps.shift.call
    print! if Computer.debug?
  end

  def state_complete?
    steps.empty?
  end

  private

  def switch_state!
    states.rotate!
    load_steps!
  end

  def current_state
    states.first
  end

  def load_steps!
    case current_state
    when :fetch_first_byte
      @steps = Transaction.get(:fetch_first_byte)
    when :fetch_second_byte
      @steps = load_second_byte? ? Transaction.get(:fetch_second_byte) : []
    when :execute_instruction
      @steps = Instruction.get(opcode)
    end
  end

  def load_second_byte?
    Instruction::OPCODES[opcode] == 2
  end

  def opcode
    Instruction::OPCODES.keys[Computer::INSTRUCTION.value >> 12]
  end

  def print!
    output = ''

    case current_state
    when :fetch_first_byte
      output += "#{Computer::STACK.to_hex} - |" if steps.length == 2
      output += '#'
    when :fetch_second_byte
      output += '#'
    when :execute_instruction
      output += '#'
      output += "| - #{opcode}\n" if state_complete?
    end

    Computer.log(output)
  end
end
