class Assembler
  OPCODES = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI CMP CMPI)

  TERMINALS = {
    /^;.*/ => 'COMMENT',
    /^(#{OPCODES.join('|')})\b/i => 'OPCODE',
    /^[A-Z]\w*\b/i => 'IDENTIFIER',
    /^0x[0-9A-F]+\b/i => 'VALUE',
    /^=/i => 'ASSIGNMENT',
    /^\s+/i => 'WHITESPACE',
  }

  LINE = /^([\w=\s]+)?(;.*)?$/i
  COMMENT = /^COMMENT$/
  IDENTIFIER = /^IDENTIFIER/
  IDENTIFIER_ASSIGNMENT = /^IDENTIFIER WHITESPACE ASSIGNMENT WHITESPACE VALUE( WHITESPACE COMMENT)?$/
  INSTRUCTION = /^OPCODE WHITESPACE (IDENTIFIER|VALUE)( WHITESPACE COMMENT)?$/

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

      return [] if token_string(tokens) =~ COMMENT

      if token_string(tokens) =~ IDENTIFIER_ASSIGNMENT
        define_identifier(tokens)
        return []
      elsif token_string(tokens) =~ IDENTIFIER
        define_identifier(tokens)
        tokens.shift(2)
      end

      assemble_microcode(tokens)
    end

    def assemble_microcode(tokens)
      return [] if tokens.empty?

      fail 'invalid instruction' unless token_string(tokens) =~ INSTRUCTION

      instruction_data = []
      instruction_data << get_opcode(tokens[0][:value])

      operand = tokens[2][:type] == 'VALUE' ? tokens[2][:value].to_i(16) : get_identifier(tokens[2][:value])

      if %w(JMP JC JZ LD ST NOR ADD CMP).include?(tokens[0][:value])
        instruction_data << ((operand & 0xf00) >> 0x8)
        instruction_data << ((operand & 0x0f0) >> 0x4)
        instruction_data << (operand & 0x00f)
      elsif %w(LDI STC IN OUT NORI ADDI CMPI).include?(tokens[0][:value])
        instruction_data << (operand & 0x00f)
      end

      instruction_data
    end

    def get_opcode(mnemonic)
      OPCODES.index(mnemonic.upcase)
    end

    def define_identifier(tokens)
      fail 'invalid identifier' unless token_string(tokens) =~ IDENTIFIER

      if token_string(tokens) =~ IDENTIFIER_ASSIGNMENT
        @identifiers[tokens[0][:value]] = tokens[4][:value].to_i(16)
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
        end
      end

      tokens
    end

    def token_string(tokens)
      tokens.map{ |t| t[:type] }.join(' ')
    end
end
