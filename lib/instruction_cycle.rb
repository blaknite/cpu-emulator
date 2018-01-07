require 'instruction_cycle/state'

class InstructionCycle
  def initialize
    reset!
  end

  def reset!
    @states = [Fetch.new, Execute.new]
    current_state.reset!
  end

  def clock!
    switch_state! if current_state.complete?
    current_state.clock!
    print! if Computer.debug?
  end

  private

  def current_state
    @states.first
  end

  def switch_state!
    @states.rotate!
    current_state.reset!
  end

  def print!
    Computer.log current_state.to_s
  end
end
