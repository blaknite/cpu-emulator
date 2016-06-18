class Assembler
  OPCODES = %w(NOP JMP JC JZ LD LDI LDM ST STC STM NOR NORI ADD ADDI CMP CMPI)

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

      return [] if build_phrase(tokens) =~ COMMENT

      define_identifier(tokens) if build_phrase(tokens) =~ IDENTIFIER

      tokens.shift until tokens.empty? || tokens[0][:type] == 'OPCODE'

      return [] if tokens.empty?

      assemble_microcode(tokens)
    end

    def assemble_microcode(tokens)
      fail 'invalid instruction' unless build_phrase(tokens) =~ INSTRUCTION

      instruction_data = [get_opcode(tokens[0][:value])]

      operand = tokens[2][:type] == 'VALUE' ? tokens[2][:value].to_i(16) : get_identifier(tokens[2][:value])

      if %w(JMP JC JZ LDM STM).include?(tokens[0][:value])
        instruction_data << ((operand & 0xf00) >> 0x8)
        instruction_data << ((operand & 0x0f0) >> 0x4)
        instruction_data << (operand & 0x00f)
      elsif %w(LD LDI ST STC NOR NORI ADD ADDI CMP CMPI).include?(tokens[0][:value])
        instruction_data << (operand & 0x00f)
      end

      instruction_data
    end

    def get_opcode(mnemonic)
      OPCODES.index(mnemonic.upcase)
    end

    def define_identifier(tokens)
      fail 'invalid identifier' unless build_phrase(tokens) =~ IDENTIFIER

      if build_phrase(tokens) =~ IDENTIFIER_ASSIGNMENT
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

          break
        end
      end

      tokens
    end

    def build_phrase(tokens)
      tokens.map{ |t| t[:type] }.join(' ')
    end
end
