class Assembler
  OPCODE_MAP = %w(NOP JMP JC JZ LD LDI ST STC IN OUT NOR NORI ADD ADDI CMP CMPI)

  def self.assemble_program!(program)
    assembler = self.new(program)
    assembler.assemble!
  end

  def initialize(program)
    @program = program
    @instructions = @program.upcase.lines.map(&:strip)
    @labels = {}
    @program_data = []
  end

  def assemble!
    print 'Assembling program'

    2.times{ assemble }
    validate_labels

    print "complete!\n"

    @program_data.map{ |pd| '0x' + pd.to_s(16) }.join(' ')
  end

  private

    def assemble
      @program_data = []
      @instructions.each do |i|
        assemble_instruction(i)
        print '.'
      end
    end

    def validate_labels
      @instructions.each do |i|
        validate_label(i)
        print '.'
      end
    end

    def assemble_instruction(instruction)
      instruction = instruction.split(';')[0]

      return if instruction.nil? || instruction.empty?

      parts = instruction.split(' ')

      fail 'invalid instruction' unless OPCODE_MAP.include?(parts[0]) || OPCODE_MAP.include?(parts[1])

      unless OPCODE_MAP.include?(parts[0])
        @labels[parts[0]] = @program_data.length
        parts.shift
      end

      @program_data << OPCODE_MAP.index(parts[0])

      if %w(JMP JC JZ).include?(parts[0])
        operand = parts[1] =~ /^(0x)?\d+$/ ? parts[1].to_i(16) : @labels[parts[1]] || 0x000

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
    end

    def validate_label(instruction)
      instruction = instruction.split(';')[0]

      return if instruction.nil? || instruction.empty?

      parts = instruction.split(' ')

      parts.shift unless OPCODE_MAP.include?(parts[0])

      if %w(JMP JC JZ).include?(parts[0])
        unless parts[1] =~ /^(0x)?\d+$/
          fail 'invalid label' if @labels[parts[1]].nil?
        end
      end
    end
end
