require 'lb_100'

RSpec.describe LB100 do
  describe 'new' do
    it 'initializes an valid LB100 computer sytem' do
      lb_100 = LB100.new

      expect(lb_100).to be_a(LB100)

      expect(lb_100.a).to be_a(Register)
      expect(lb_100.a.bits).to eq(4)

      expect(lb_100.c).to be_a(Register)
      expect(lb_100.c.bits).to eq(1)

      expect(lb_100.pc).to be_a(Register)
      expect(lb_100.pc.bits).to eq(12)

      expect(lb_100.z).to be_a(Register)
      expect(lb_100.z.bits).to eq(1)
    end
  end
end
