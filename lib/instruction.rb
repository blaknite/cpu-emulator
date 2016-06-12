require 'value'

class Instruction < Value
  def initialize(value)
    super(value)
  end

  def opcode
    @opcode ||= self.to_i >> 4
  end

  def operand
    @operand ||= Value.new(self[4..-1].join.to_i(2))
  end

  def bits
    8
  end

  private

    def set(new_value)
      fail 'value is not an integer' unless new_value.is_a?(Integer)
      replace(new_value.to_s(2).chars.last(bits).map(&:to_i))
      unshift(0) until length >= bits
    end
end
