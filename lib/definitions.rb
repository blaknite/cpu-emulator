require 'transaction'
require 'instruction'

##
# TRANSACTION DEFINITIONS

##
# Sets the bus to zero
Transaction.define :clear_bus do
  define_step -> { Computer::BUS.value = 0 }
end

##
# Incerments the top-most value on the stack for program execution
Transaction.define :increment_program do
  define_step -> { Computer::STACK.value += 1 }
end

##
# Moves a register value to the bus
Transaction.define :register_to_bus do
  define_step -> { Computer::BUS.value = Computer::REGISTER[Computer::INSTRUCTION.value >> 8 & 0xf].value }
end

##
# Moves the bust value to A
Transaction.define :bus_to_a do
  define_step -> { Computer::A.value = Computer::BUS.value }
  include_transaction :clear_bus
end

##
# Moves the bus value to B
Transaction.define :bus_to_b do
  define_step -> { Computer::B.value = Computer::BUS.value }
  include_transaction :clear_bus
end

##
# Loads the oparand from memory into the instruction register
Transaction.define :operand_to_bus do
  define_step -> { Computer::BUS.value = Computer::INSTRUCTION.value }
end

##
# Moves the A value to the bus
Transaction.define :a_to_bus do
  define_step -> { Computer::BUS.value = Computer::A.value }
end

##
# Performs a logical NOR operation on the values A and B
Transaction.define :alu_nor do
  define_step -> {
    result = ~(Computer::A.value | Computer::B.value)
    Computer::BUS.value = result
    Computer::CARRY.value = 0
    Computer::ZERO.value = result & 0xff == 0 ? 1 : 0
  }
end

##
# Adds the values A and B
Transaction.define :alu_add do
  define_step -> {
    result = Computer::A.value + Computer::B.value
    Computer::BUS.value = result
    Computer::CARRY.value = result[8]
    Computer::ZERO.value = result & 0xff == 0 ? 1 : 0
  }
end

##
# Compares the values A and B
Transaction.define :alu_cmp do
  define_step -> {
    result = Computer::A.value - Computer::B.value
    Computer::CARRY.value = result[8]
    Computer::ZERO.value = result & 0xff == 0 ? 1 : 0
  }
end

##
# Fetches the first byte of an instruction
Transaction.define :fetch_first_byte do
  define_step -> { Computer::BUS.value = Computer::RAM[Computer::STACK.value].value }
  define_step -> { Computer::INSTRUCTION.value = Computer::BUS.value << 0x08 }
  include_transaction :clear_bus
  include_transaction :increment_program
end

##
# Fetches the second byte of an instruction
Transaction.define :fetch_second_byte do
  define_step -> { Computer::BUS.value = Computer::RAM[Computer::STACK.value].value }
  define_step -> { Computer::INSTRUCTION.value += Computer::BUS.value }
  include_transaction :clear_bus
  include_transaction :increment_program
end


##
# INSTRUCTION DEFINITIONS

##
# Jump to memory address unconditionally
Instruction.define :JMP do
  define_step -> { Computer::STACK.value = Computer::INSTRUCTION.value }
end

##
# Jump to memory address if carry
Instruction.define :JC do
  define_step -> { Computer::STACK.value = Computer::INSTRUCTION.value if Computer::CARRY.value == 1 }
end

##
# Jump to memory address if zero
Instruction.define :JZ do
  define_step -> { Computer::STACK.value = Computer::INSTRUCTION.value if Computer::ZERO.value == 1 }
end

##
# Jump to memory address and save previous address to stack
Instruction.define :CALL do
  define_step -> { Computer::STACK.pointer.value -= 1 }
  define_step -> { Computer::STACK.value = Computer::INSTRUCTION.value }
end

##
# Jump to memory address one down in stack
Instruction.define :RET do
  define_step -> { Computer::STACK.pointer.value += 1 }
end

##
# Load register to accumulator
Instruction.define :LD do
  include_transaction :register_to_bus
  include_transaction :bus_to_a
end

##
# Load immediate value to accumulator
Instruction.define :LDI do
  include_transaction :operand_to_bus
  include_transaction :bus_to_a
end

##
# Load memory to accumulator
Instruction.define :LDM do
  define_step -> { Computer::BUS.value = Computer::RAM[Computer::INSTRUCTION.value & 0xfff].value }
  include_transaction :bus_to_a
end

##
# Store accumulator in register
Instruction.define :ST do
  include_transaction :a_to_bus
  define_step -> { Computer::REGISTER[Computer::INSTRUCTION.value >> 8 & 0xf].value = Computer::BUS.value }
  include_transaction :clear_bus
end

##
# Store accumulator in memory
Instruction.define :STM do
  include_transaction :a_to_bus
  define_step -> { Computer::RAM[Computer::INSTRUCTION.value & 0xfff].value = Computer::BUS.value }
  include_transaction :clear_bus
end

##
# Logical NOR of register and accumulator
Instruction.define :NOR do
  include_transaction :register_to_bus
  include_transaction :bus_to_b
  include_transaction :alu_nor
  include_transaction :bus_to_a
end

##
# Logical NOR of immediate value and accumulator
Instruction.define :NORI do
  include_transaction :operand_to_bus
  include_transaction :bus_to_b
  include_transaction :alu_nor
  include_transaction :bus_to_a
end

##
# Add register to accumulator
Instruction.define :ADD do
  include_transaction :register_to_bus
  include_transaction :bus_to_b
  include_transaction :alu_add
  include_transaction :bus_to_a
end

##
# Add immediate value to accumulator
Instruction.define :ADDI do
  include_transaction :operand_to_bus
  include_transaction :bus_to_b
  include_transaction :alu_add
  include_transaction :bus_to_a
end

##
# Compare register with accumulator
Instruction.define :CMP do
  include_transaction :register_to_bus
  include_transaction :bus_to_b
  include_transaction :alu_cmp
end

##
# Compare immediate value with accumulator
Instruction.define :CMPI do
  include_transaction :operand_to_bus
  include_transaction :bus_to_b
  include_transaction :alu_cmp
end
