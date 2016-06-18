require 'computer'

RSpec.describe Computer do
  describe 'new' do
    it 'initializes an valid Computer computer sytem' do
      computer = Computer.new

      expect(computer).to be_a(Computer)

      # this is a 4-bit computer so the accumulator must be a 4-bit register
      expect(computer.a).to be_a(Register)
      expect(computer.a.bits).to eq(4)

      # a 4-bit buffer is required to perform operations on the accumulator
      expect(computer.b).to be_a(Register)
      expect(computer.b.bits).to eq(4)

      # the carry flag must be a 1-bit register
      expect(computer.c).to be_a(Register)
      expect(computer.c.bits).to eq(1)

      # the input must be an array of 16 4-bit registers
      expect(computer.in).to be_a(Array)
      expect(computer.in.length).to eq(16)
      computer.in.each do |r|
        expect(r).to be_a(Register)
        expect(computer.a.bits).to eq(4)
      end

      # the instruction counter must be a 3-bit register
      expect(computer.ic).to be_a(Register)
      expect(computer.ic.bits).to eq(3)

      # the output must be an array of 16 4-bit registers
      expect(computer.out).to be_a(Array)
      expect(computer.out.length).to eq(16)
      computer.out.each do |r|
        expect(r).to be_a(Register)
        expect(computer.a.bits).to eq(4)
      end

      # the program counter must be a 12-bit regisiter so we can store memory addresses
      expect(computer.pc).to be_a(Register)
      expect(computer.pc.bits).to eq(12)

      # the ram must be an array of 4096 4-bit registers
      expect(computer.ram).to be_a(Array)
      expect(computer.ram.length).to eq(4096)
      computer.ram.each do |r|
        expect(r).to be_a(Register)
        expect(computer.a.bits).to eq(4)
      end

      # the zero flag must be a 1-bit register
      expect(computer.z).to be_a(Register)
      expect(computer.z.bits).to eq(1)
    end
  end
end
