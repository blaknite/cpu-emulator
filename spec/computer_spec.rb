require 'spec_helper'

RSpec.describe Computer do
  before do
    Computer.reset!
  end

  it 'is a valid computer' do
    # the frequency must be set
    expect(Computer::FREQUENCY).to be_a Integer

    # this is a 8-bit computer so the accumulator must be a 8-bit register
    expect(Computer::A).to be_a Register
    expect(Computer::A.bits).to eq 8

    # B is also 8 bits
    expect(Computer::A).to be_a Register
    expect(Computer::A.bits).to eq 8

    # the bus must be 8 bits
    expect(Computer::BUS).to be_a Register
    expect(Computer::BUS.bits).to eq 8

    # the carry flag must be a 1-bit register
    expect(Computer::CARRY).to be_a Register
    expect(Computer::CARRY.bits).to eq 1

    # the instruction register must be a 16-bit register
    expect(Computer::INSTRUCTION).to be_a Register
    expect(Computer::INSTRUCTION.bits).to eq 16

    # the ram must be 4096, 8-bit registers
    expect(Computer::RAM).to be_a Array
    expect(Computer::RAM.length).to eq 4096
    Computer::RAM.each do |r|
      expect(r).to be_a Register
      expect(r.bits).to eq 8
    end

    # the registers must be an array of 16 8-bit registers
    expect(Computer::REGISTER).to be_a Array
    expect(Computer::REGISTER.length).to eq 16
    Computer::REGISTER.each do |r|
      expect(r).to be_a Register
      expect(r.bits).to eq 8
    end

    # the stack must be four, 12-bit regisiters so we can store memory addresses
    expect(Computer::STACK).to be_a Stack
    expect(Computer::STACK.registers.length).to eq 4
    Computer::STACK.registers.each do |r|
      expect(r).to be_a Register
      expect(r.bits).to eq 12
    end

    # the zero flag must be a 1-bit register
    expect(Computer::ZERO).to be_a Register
    expect(Computer::ZERO.bits).to eq 1
  end

  context 'when exectuing a JMP instruction' do
    before do
      Computer::RAM[0x000].value = 0x00
      Computer::RAM[0x001].value = 0x4c

      9.times { Computer.clock! }
    end

    it 'sets the value of the top of the stack' do
      expect(Computer::STACK.value).to eq 0x04c
    end
  end

  context 'when exectuing a JC instruction' do
    before do
      Computer::RAM[0x000].value = 0x10
      Computer::RAM[0x001].value = 0x4c
    end

    context 'when the carry flag is zero' do
      before do
        Computer::CARRY.value = 0

        9.times { Computer.clock! }
      end

      it 'does not set the value of the top of the stack' do
        expect(Computer::STACK.value).to eq 0x002
      end
    end

    context 'when the carry flag is one' do
      before do
        Computer::CARRY.value = 1

        9.times { Computer.clock! }
      end

      it 'sets the value of the top of the stack' do
        expect(Computer::STACK.value).to eq 0x04c
      end
    end
  end

  context 'when executing a JZ instruction' do
    before do
      Computer::RAM[0x000].value = 0x20
      Computer::RAM[0x001].value = 0x4c
    end

    context 'when the zero flag is zero' do
      before do
        Computer::ZERO.value = 0

        9.times { Computer.clock! }
      end

      it 'does not set the value of the top of the stack' do
        expect(Computer::STACK.value).to eq 0x002
      end
    end

    context 'when the zero flag is one' do
      before do
        Computer::ZERO.value = 1

        9.times { Computer.clock! }
      end

      it 'sets the value of the top of the stack' do
        expect(Computer::STACK.value).to eq 0x04c
      end
    end
  end

  context 'when executing a CALL instruction' do
    before do
      Computer::RAM[0x000].value = 0x30
      Computer::RAM[0x001].value = 0x4c

      9.times { Computer.clock! }
    end

    it 'sets the value of the top of the stack' do
      expect(Computer::STACK.value).to eq 0x04c
    end

    it 'pushes the top value down the stack' do
      expect(Computer::STACK.registers[2].value).to eq 0x002
    end
  end

  context 'when executing a RET instruction' do
    before do
      Computer::RAM[0x000].value = 0x40

      Computer::STACK.registers[2].value = 0x4c

      6.times { Computer.clock! }
    end

    it 'pushes the second value up the stack' do
      expect(Computer::STACK.value).to eq 0x04c
    end
  end

  context 'when executing a LD instruction' do
    before do
      Computer::RAM[0x000].value = 0x50
      Computer::RAM[0x001].value = 0x00

      Computer::REGISTER[0x0].value = 0x4c

      7.times { Computer.clock! }
    end

    it 'should change the value of A' do
      expect(Computer::A.value).to eq 0x4c
    end
  end

  context 'when executing a LDI instruction' do
    before do
      Computer::RAM[0x000].value = 0x60
      Computer::RAM[0x001].value = 0x4c

      10.times { Computer.clock! }
    end

    it 'should change the value of A' do
      expect(Computer::A.value).to eq 0x4c
    end
  end

  context 'when executing a LDM instruction' do
    before do
      Computer::RAM[0x000].value = 0x7f
      Computer::RAM[0x001].value = 0xff
      Computer::RAM[0xfff].value = 0x4c

      10.times { Computer.clock! }
    end

    it 'should change the value of A' do
      expect(Computer::A.value).to eq 0x4c
    end
  end

  context 'when executing a ST instruction' do
    before do
      Computer::RAM[0x000].value = 0x80
      Computer::RAM[0x001].value = 0x00

      Computer::A.value = 0x4c

      7.times { Computer.clock! }
    end

    it 'should change the value of A' do
      expect(Computer::REGISTER[0x0].value).to eq 0x4c
    end
  end

  context 'when executing a STM instruction' do
    before do
      Computer::RAM[0x000].value = 0x9f
      Computer::RAM[0x001].value = 0xff

      Computer::A.value = 0x4c

      10.times { Computer.clock! }
    end

    it 'should change the value of A' do
      expect(Computer::RAM[0xfff].value).to eq 0x4c
    end
  end

  context 'when executing a NOR instruction' do
    before do
      Computer::RAM[0x000].value = 0xa0
    end

    context 'when executing' do
      before do
        Computer::RAM[0x001].value = 0x00

        Computer::A.value = '00000000'.to_i(2)
        Computer::REGISTER[0x0].value = '01010101'.to_i(2)

        10.times { Computer.clock! }
      end

      it 'should change the value of A' do
        expect(Computer::A.to_bin).to eq '10101010'
      end
    end

    context 'when the result is zero' do
      before do
        Computer::RAM[0x001].value = 0x00

        Computer::ZERO.value = 0x0

        Computer::A.value = '10101010'.to_i(2)
        Computer::REGISTER[0x0].value = '01010101'.to_i(2)

        10.times { Computer.clock! }
      end

      it 'sets the value of ZERO to 1' do
        expect(Computer::ZERO.value).to eq 0x1
      end
    end

    context 'when the result is not zero' do
      before do
        Computer::RAM[0x001].value = 0x00

        Computer::ZERO.value = 0x1

        Computer::A.value = '00000000'.to_i(2)
        Computer::REGISTER[0x0].value = '01010101'.to_i(2)

        10.times { Computer.clock! }
      end

      it 'sets the value of ZERO to 0' do
        expect(Computer::ZERO.value).to eq 0x0
      end
    end
  end

  context 'when executing a NORI instruction' do
    before do
      Computer::RAM[0x000].value = 0xb0
    end

    context 'when executing' do
      before do
        Computer::RAM[0x001].value = '01010101'.to_i(2)

        Computer::A.value = '00000000'.to_i(2)

        13.times { Computer.clock! }
      end

      it 'should change the value of A' do
        expect(Computer::A.to_bin).to eq '10101010'
      end
    end

    context 'when the result is zero' do
      before do
        Computer::RAM[0x001].value = '01010101'.to_i(2)

        Computer::ZERO.value = 0x0

        Computer::A.value = '10101010'.to_i(2)

        13.times { Computer.clock! }
      end

      it 'sets the value of ZERO to 1' do
        expect(Computer::ZERO.value).to eq 0x1
      end
    end

    context 'when the result is not zero' do
      before do
        Computer::RAM[0x001].value = '01010101'.to_i(2)

        Computer::ZERO.value = 0x1

        Computer::A.value = '00000000'.to_i(2)

        13.times { Computer.clock! }
      end

      it 'sets the value of ZERO to 0' do
        expect(Computer::ZERO.value).to eq 0x0
      end
    end
  end

  context 'when executing a ADD instruction' do
    before do
      Computer::RAM[0x000].value = 0xc0
      Computer::RAM[0x001].value = 0x00
    end

    context 'when executing' do
      before do
        Computer::A.value = 0x01
        Computer::REGISTER[0x0].value = 0x01

        10.times { Computer.clock! }
      end

      it 'should change the value of A' do
        expect(Computer::A.value).to eq 0x02
      end
    end

    context 'when the result is zero' do
      before do
        Computer::ZERO.value = 0x0

        Computer::A.value = 0xff
        Computer::REGISTER[0x0].value = 0x01

        10.times { Computer.clock! }
      end

      it 'sets the value of zero to 1' do
        expect(Computer::ZERO.value).to eq 0x1
      end
    end

    context 'when the result is not zero' do
      before do
        Computer::ZERO.value = 0x1

        Computer::A.value = 0xfe
        Computer::REGISTER[0x0].value = 0x01

        10.times { Computer.clock! }
      end

      it 'sets the value of zero to 0' do
        expect(Computer::ZERO.value).to eq 0x0
      end
    end

    context 'when the operation results in a carry' do
      before do
        Computer::CARRY.value = 0x0

        Computer::A.value = 0xff
        Computer::REGISTER[0x0].value = 0x01

        10.times { Computer.clock! }
      end

      it 'sets the value of carry to 1' do
        expect(Computer::CARRY.value).to eq 0x1
      end
    end

    context 'when the operation dose not result in a carry' do
      before do
        Computer::CARRY.value = 0x1

        Computer::A.value = 0xfe
        Computer::REGISTER[0x0].value = 0x01

        10.times { Computer.clock! }
      end

      it 'sets the value of carry to 0' do
        expect(Computer::CARRY.value).to eq 0x0
      end
    end
  end

  context 'when executing a ADDI instruction' do
    before do
      Computer::RAM[0x000].value = 0xd0
    end

    context 'when executing' do
      before do
        Computer::RAM[0x001].value = 0x01

        Computer::A.value = 0x01

        13.times { Computer.clock! }
      end

      it 'should change the value of A' do
        expect(Computer::A.value).to eq 0x02
      end
    end

    context 'when the result is zero' do
      before do
        Computer::RAM[0x001].value = 0x00

        Computer::ZERO.value = 0x0

        Computer::A.value = 0x00

        13.times { Computer.clock! }
      end

      it 'sets the value of zero to 1' do
        expect(Computer::ZERO.value).to eq 0x1
      end
    end

    context 'when the result is not zero' do
      before do
        Computer::RAM[0x001].value = 0x01

        Computer::ZERO.value = 0x1

        Computer::A.value = 0x00

        13.times { Computer.clock! }
      end

      it 'sets the value of zero to 0' do
        expect(Computer::ZERO.value).to eq 0x0
      end
    end

    context 'when the operation results in a carry' do
      before do
        Computer::RAM[0x001].value = 0x01

        Computer::CARRY.value = 0x0

        Computer::A.value = 0xff

        13.times { Computer.clock! }
      end

      it 'sets the value of carry to 1' do
        expect(Computer::CARRY.value).to eq 0x1
      end
    end

    context 'when the operation dose not result in a carry' do
      before do
        Computer::RAM[0x001].value = 0x01

        Computer::CARRY.value = 0x1

        Computer::A.value = 0xfe

        13.times { Computer.clock! }
      end

      it 'sets the value of carry to 0' do
        expect(Computer::CARRY.value).to eq 0x0
      end
    end
  end

  context 'when executing a CMP instruction' do
    before do
      Computer::RAM[0x000].value = 0xe0
      Computer::RAM[0x001].value = 0x00
    end

    context 'when executing' do
      before do
        Computer::REGISTER[0x0].value = 0x01

        9.times { Computer.clock! }
      end

      it 'should not change the value of A' do
        expect(Computer::A.value).to eq 0x00
      end
    end

    context 'when the result is zero' do
      before do
        Computer::ZERO.value = 0x0

        Computer::A.value = 0xff
        Computer::REGISTER[0x0].value = 0xff

        9.times { Computer.clock! }
      end

      it 'sets the value of zero to 1' do
        expect(Computer::ZERO.value).to eq 0x1
      end
    end

    context 'when the result is not zero' do
      before do
        Computer::ZERO.value = 0x1

        Computer::A.value = 0xff
        Computer::REGISTER[0x0].value = 0x01

        9.times { Computer.clock! }
      end

      it 'sets the value of zero to 0' do
        expect(Computer::ZERO.value).to eq 0x0
      end
    end

    context 'when the operation results in a carry' do
      before do
        Computer::CARRY.value = 0x0

        Computer::A.value = 0x00
        Computer::REGISTER[0x0].value = 0x01

        9.times { Computer.clock! }
      end

      it 'sets the value of carry to 1' do
        expect(Computer::CARRY.value).to eq 0x1
      end
    end

    context 'when the operation dose not result in a carry' do
      before do
        Computer::CARRY.value = 0x1

        Computer::A.value = 0xff
        Computer::REGISTER[0x0].value = 0x01

        9.times { Computer.clock! }
      end

      it 'sets the value of carry to 0' do
        expect(Computer::CARRY.value).to eq 0x0
      end
    end
  end

  context 'when executing a CMPI instruction' do
    before do
      Computer::RAM[0x000].value = 0xf0
    end

    context 'when executing' do
      before do
        Computer::RAM[0x001].value = 0x01

        12.times { Computer.clock! }
      end

      it 'should not change the value of A' do
        expect(Computer::A.value).to eq 0x00
      end
    end

    context 'when the result is zero' do
      before do
        Computer::RAM[0x001].value = 0xff

        Computer::ZERO.value = 0x0

        Computer::A.value = 0xff

        12.times { Computer.clock! }
      end

      it 'sets the value of zero to 1' do
        expect(Computer::ZERO.value).to eq 0x1
      end
    end

    context 'when the result is not zero' do
      before do
        Computer::RAM[0x001].value = 0x00

        Computer::ZERO.value = 0x1

        Computer::A.value = 0xff

        12.times { Computer.clock! }
      end

      it 'sets the value of zero to 0' do
        expect(Computer::ZERO.value).to eq 0x0
      end
    end

    context 'when the operation results in a carry' do
      before do
        Computer::RAM[0x001].value = 0x01

        Computer::CARRY.value = 0x0

        Computer::A.value = 0x00

        12.times { Computer.clock! }
      end

      it 'sets the value of carry to 1' do
        expect(Computer::CARRY.value).to eq 0x1
      end
    end

    context 'when the operation dose not result in a carry' do
      before do
        Computer::RAM[0x001].value = 0x01

        Computer::CARRY.value = 0x1

        Computer::A.value = 0xff

        12.times { Computer.clock! }
      end

      it 'sets the value of carry to 0' do
        expect(Computer::CARRY.value).to eq 0x0
      end
    end
  end

  context 'when running a program' do
    before do
      Computer.load_file('spec/support/test.bin')
      46.times { Computer.clock! }
    end

    it 'should run the program' do
      expect(Computer::RAM[0xfff].value).to eq 8
    end
  end
end
