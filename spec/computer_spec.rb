require 'computer'

RSpec.describe Computer do
  describe 'new' do
    it 'initializes an valid Computer computer sytem' do
      computer = Computer.new

      expect(computer).to be_a(Computer)

      # this is a 8-bit computer so the accumulator must be a 8-bit register
      expect(computer.a).to be_a(Register)
      expect(computer.a.bits).to eq(8)

      # the bus must be 8 bits
      expect(computer.bus).to be_a(Register)
      expect(computer.bus.bits).to eq(8)

      # the carry flag must be a 1-bit register
      expect(computer.c).to be_a(Register)
      expect(computer.c.bits).to eq(1)

      # the instruction counter must be a 5-bit register
      expect(computer.ic).to be_a(Register)
      expect(computer.ic.bits).to eq(5)

      # the instruction register must be a 16-bit register
      expect(computer.i).to be_a(Register)
      expect(computer.i.bits).to eq(16)

      # the program counter must be a 12-bit regisiter so we can store memory addresses
      expect(computer.pc).to be_a(Register)
      expect(computer.pc.bits).to eq(12)

      # the ram must be an array of 2^12 8-bit registers
      expect(computer.ram).to be_a(Array)
      expect(computer.ram.length).to eq(2**12)
      computer.ram.each do |r|
        expect(r).to be_a(Register)
        expect(r.bits).to eq(8)
      end

      # the registers must be an array of 16 8-bit registers
      expect(computer.r).to be_a(Array)
      expect(computer.r.length).to eq(16)
      computer.r.each do |r|
        expect(r).to be_a(Register)
        expect(r.bits).to eq(8)
      end

      # temp register a for the alu
      expect(computer.ta).to be_a(Register)
      expect(computer.ta.bits).to eq(8)

      # temp register b for the alu
      expect(computer.tb).to be_a(Register)
      expect(computer.tb.bits).to eq(8)

      # the zero flag must be a 1-bit register
      expect(computer.z).to be_a(Register)
      expect(computer.z.bits).to eq(1)
    end
  end
end
