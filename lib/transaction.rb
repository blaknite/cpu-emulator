class Transaction
  REPOSITORY = {}

  def self.get(name)
    REPOSITORY[name].dup || fail("unregistered transaction: #{name}")
  end

  def self.define(name, &block)
    REPOSITORY[name] = new(name, &block).call
  end

  def self.clear!
    REPOSITORY.clear
  end

  def initialize(name, &block)
    @name = name
    @steps = []
    instance_eval(&block)
  end

  def call
    @steps
  end

  private

  def define_step(step)
    @steps << step
  end

  def include_transaction(name)
    @steps = @steps + Transaction.get(name)
  end
end
