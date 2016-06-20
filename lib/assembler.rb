class Assembler
  OPCODES = %w(JMP JC JZ CALL RET LD LDI LDM ST STM NOR NORI ADD ADDI CMP CMPI)

  TERMINALS = {
    /^;.*/ => 'COMMENT',
    /^(#{OPCODES.join('|')})\b/i => 'OPCODE',
    /^[A-Z]\w*\b/i => 'IDENTIFIER',
    /^0b[0-9A-F]+\b/i => 'BINARY',
    /^[0-9]+\b/i => 'DECIMAL',
    /^0x[0-9A-F]+\b/i => 'HEXIDECIMAL',
    /^(('.')|("."))/i => 'LETTER',
    /^=/i => 'ASSIGNMENT',
    /^\s+/i => 'WHITESPACE',
  }

  LINE = /^([\w=\s(('.')|("."))]+)?(;.*)?$/i
  COMMENT = /^COMMENT$/
  IDENTIFIER = /^IDENTIFIER/
  IDENTIFIER_ASSIGNMENT = /^IDENTIFIER WHITESPACE ASSIGNMENT WHITESPACE (BINARY|DECIMAL|HEXIDECIMAL|LETTER)( WHITESPACE COMMENT)?$/
  INSTRUCTION = /^OPCODE( WHITESPACE (IDENTIFIER|BINARY|DECIMAL|HEXIDECIMAL|LETTER))?( WHITESPACE COMMENT)?$/

  def self.assemble_program!(program)
    assembler = self.new(program)
    assembler.assemble!
  end

  def initialize(program)
    @program = program
    @instructions = @program.lines.map(&:strip)
    @identifiers = {}
    @macros = {}
  end

  def assemble!
    print 'Assembling program'

    begin
      2.times{ assemble }

      print "complete!\n"

      @program_data.map{ |pd| '0x' + pd.to_s(16) }.join(' ')
    rescue StandardError => e
      print "failed!\n"

      message = "#{e} at line #{@current_line}."

      print message[0].upcase + message[1..-1]
    end
  end

  private

    def assemble
      @program_data = []

      @instructions.each_with_index do |instruction, index|
        @current_line = index + 1
        @program_data += assemble_instruction(instruction)
        print '.'
      end
    end

    def assemble_instruction(instruction)
      fail 'invalid character' unless instruction =~ LINE

      tokens = find_tokens(instruction)

      return [] if build_phrase(tokens) =~ COMMENT

      define_identifier(tokens) if build_phrase(tokens) =~ IDENTIFIER

      tokens.shift until tokens.empty? || tokens[0][:type] == 'OPCODE'

      return [] if tokens.empty?

      assemble_microcode(tokens)
    end

    def assemble_microcode(tokens)
      fail 'invalid instruction' unless build_phrase(tokens) =~ INSTRUCTION

      instruction_data = [get_opcode(tokens[0][:value]) << 4]

      return instruction_data if %w(RET).include?(tokens[0][:value])

      case tokens[2][:type]
      when 'BINARY'
        operand = tokens[2][:value].to_i(2)
      when 'DECIMAL'
        operand = tokens[2][:value].to_i
      when 'HEXIDECIMAL'
        operand = tokens[2][:value].to_i(16)
      when 'LETTER'
        operand = tokens[2][:value][1].ord
      else
        operand = get_identifier(tokens[2][:value])
      end

      if %w(JMP JC JZ CALL LDM STM).include?(tokens[0][:value])
        fail 'operand must be 12-bits or less' if operand > 0xfff
        instruction_data[0] += ((operand & 0xf00) >> 0x8)
        instruction_data << (operand & 0xff)
      elsif %w(LDI NORI ADDI CMPI).include?(tokens[0][:value])
        fail 'operand must be 8-bits or less' if operand > 0xff
        instruction_data << (operand & 0xff)
      elsif %w(LD ST NOR ADD CMP).include?(tokens[0][:value])
        fail 'operand must be 4-bits or less' if operand > 0xf
        instruction_data[0] += (operand & 0xf)
      end

      instruction_data
    end

    def get_opcode(mnemonic)
      OPCODES.index(mnemonic.upcase)
    end

    def define_identifier(tokens)
      fail 'invalid identifier' unless build_phrase(tokens) =~ IDENTIFIER

      if build_phrase(tokens) =~ IDENTIFIER_ASSIGNMENT
        case tokens[4][:type]
        when 'BINARY'
          @identifiers[tokens[0][:value]] = tokens[4][:value].to_i(2)
        when 'DECIMAL'
          @identifiers[tokens[0][:value]] = tokens[4][:value].to_i
        when 'HEXIDECIMAL'
          @identifiers[tokens[0][:value]] = tokens[4][:value].to_i(16)
        when 'LETTER'
          @identifiers[tokens[0][:value]] = tokens[4][:value][1].ord
        end
      else
        @identifiers[tokens[0][:value]] = @program_data.length
      end
    end

    def get_identifier(name)
      fail 'undefined identifier' unless @instructions.any?{ |i| i =~ /^#{name}/i }

      @identifiers[name.upcase] || 0x000
    end

    def find_tokens(instruction)
      instruction = instruction.dup
      tokens = []

      while instruction.length > 0 do
        TERMINALS.each do |regex, type|
          matches = instruction.scan(regex).flatten.compact

          next if matches.empty?

          tokens << { type: type, value: matches.first }

          instruction.sub!(regex, '')

          break
        end
      end

      tokens
    end

    def build_phrase(tokens)
      tokens.map{ |t| t[:type] }.join(' ')
    end
end
