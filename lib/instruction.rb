require 'value'

class Instruction < Value
  def initialize(value: 0)
    super(value: value)
  end

  def opcode
    @opcode ||= self.value.to_s(16)[0].to_i(16)
  end

  def operand
    @operand ||= Value.new(value: self.value.to_s(16)[1].to_i(16))
  end

  private

    def value=(new_value)
      fail 'value is not an integer' unless new_value.is_a?(Integer)
      fail 'value is larger than 8 bits' if new_value > 0xff
      @value = new_value
    end
end
