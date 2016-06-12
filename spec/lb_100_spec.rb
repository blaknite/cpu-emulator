require 'lb_100'

RSpec.describe LB100 do
  describe 'new' do
    it 'initializes an valid LB100 computer sytem' do
      lb_100 = LB100.new

      expect(lb_100).to be_a(LB100)

      # this is a 4-bit computer so the accumulator must be a 4-bit register
      expect(lb_100.a).to be_a(Register)
      expect(lb_100.a.bits).to eq(4)

      # the carry flag must be a 1-bit register
      expect(lb_100.c).to be_a(Register)
      expect(lb_100.c.bits).to eq(1)

      # the program counter must be a 12-bit regisiter so we can store memory addresses
      expect(lb_100.pc).to be_a(Register)
      expect(lb_100.pc.bits).to eq(12)

      # the ram must be an array of 4096 4-bit registers
      expect(lb_100.ram).to be_a(Array)
      expect(lb_100.ram.length).to eq(4096)
      lb_100.ram.each do |r|
        expect(r).to be_a(Register)
        expect(lb_100.a.bits).to eq(4)
      end

      # the zero flag must be a 1-bit register
      expect(lb_100.z).to be_a(Register)
      expect(lb_100.z.bits).to eq(1)
    end
  end
end
