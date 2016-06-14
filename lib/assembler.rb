class Assembler
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI CMP CMPI)

  def self.assemble_program!(program)
    assembler = self.new(program)
    assembler.assemble!
  end

  def initialize(program)
    @program = program
    @labels = {}
    @program_data = []
  end

  def assemble!
      print 'Assembling program'

      2.times do |n|
        @program_data = []
        @program.upcase.lines.map(&:strip).each{ |i| assemble_instruction(i, n) }
      end

      print "complete!\n"

      @program_data.map{ |pd| '0x' + pd.to_s(16)  }.join(' ')
  end

  private

    def assemble_instruction(instruction, pass)
      return if instruction.empty? || instruction[0] == ';'

      parts = instruction.split(' ')

      fail 'invalid instruction' unless OPCODE_MAP.include?(parts[0]) || OPCODE_MAP.include?(parts[1])

      unless OPCODE_MAP.include?(parts[0])
        @labels[parts[0]] = @program_data.length if pass == 0
        parts.shift
      end

      @program_data << OPCODE_MAP.index(parts[0])

      if %w(NOP).include?(parts[0])
        # nothing to do

      elsif %w(JMP JC JZ).include?(parts[0])
        if parts[1] =~ /\d+/
          operand = parts[1].to_i(16)
        else
          if pass == 0
            operand = 0x000
          else
            fail 'no label found' unless @labels[parts[1]]
            operand = @labels[parts[1]]
          end
        end

        @program_data << ((operand & 0xf00) >> 0x8)
        @program_data << ((operand & 0x0f0) >> 0x4)
        @program_data << (operand & 0x00f)

      elsif %w(LD ST NOR ADD CMP).include?(parts[0])
        operand = parts[1].to_i(16)

        @program_data << ((operand & 0xf00) >> 0x8)
        @program_data << ((operand & 0x0f0) >> 0x4)
        @program_data << (operand & 0x00f)

      elsif %w(LDI STC IN OUT NORI ADDI CMPI).include?(parts[0])
        operand = parts[1].to_i(16)

        @program_data << (operand.to_i & 0x00f)

      end

      print '.'
    end
end
