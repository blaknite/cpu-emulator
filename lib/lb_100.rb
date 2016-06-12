require 'alu'
require 'instruction'
require 'register'

class LB100
  attr_reader :accumulator, :carry, :program_counter, :zero

  alias_method :a, :accumulator
  alias_method :c, :carry
  alias_method :pc, :program_counter
  alias_method :z, :zero

  def initialize
    @accumulator = Register.new(4)
    @carry = Register.new(1)
    @program_counter = Register.new(12)
    @zero = Register.new(1)
  end
end
