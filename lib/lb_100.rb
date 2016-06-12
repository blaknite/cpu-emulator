require 'instruction'
require 'operation'
require 'register'
require 'value'

class LB100
  attr_reader :accumulator, :carry, :program_counter, :ram, :zero

  alias_method :a, :accumulator
  alias_method :c, :carry
  alias_method :pc, :program_counter
  alias_method :z, :zero

  def initialize
    @accumulator = Register.new(4)
    @carry = Register.new(1)
    @program_counter = Register.new(12)
    @zero = Register.new(1)
    @ram = []
    @ram << Register.new(4) until @ram.length > 0xfff
  end
end
