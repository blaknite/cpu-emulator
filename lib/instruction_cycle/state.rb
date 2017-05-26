class InstructionCycle
  class State
    attr_reader :counter, :steps

    def initialize
      @steps = []
      reset_counter!
    end

    def reset!
      reset_counter!
      reset_steps!
    end

    def clock!
      @counter += 1
      @steps.shift.call
    end

    def complete?
      @steps.empty?
    end

    def to_s
      ''
    end

    private

    def reset_counter!
      @counter = 0
    end

    def reset_steps!
      @steps = []
    end
  end

  class Fetch < State
    def to_s
      output = ''
      output += "#{Computer::STACK.to_hex} - |" if counter == 1
      output += '#'
      output
    end

    private

    def reset_steps!
      @steps = Transaction.get(:fetch_first_byte)
    end
  end

  class Execute < State
    def to_s
      output = '#'
      output += "| - #{opcode}\n" if complete?
      output
    end

    private

    def reset_steps!
      @steps = []
      @steps += Transaction.get(:fetch_second_byte) if second_byte_required?
      @steps += Instruction.get(opcode)
    end

    def opcode
      Instruction::OPCODES.keys[Computer::INSTRUCTION.value >> 12]
    end

    def second_byte_required?
      Instruction::OPCODES[opcode] == 2
    end
  end
end
