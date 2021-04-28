# Manager class for Counterparty objects
class Counterparties
  # params: hash of { "name" => Counterparty }
  def initialize(params)
    @counterparties = params
  end

  def add(counterparty)
    @counterparties[counterparty.name] = counterparty
  end

  def find(name)
    @counterparties[name]
  end
end
