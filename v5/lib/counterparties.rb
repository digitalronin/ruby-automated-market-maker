# Manager class for Counterparty objects
class Counterparties
  # list: Array of Counterparty objects
  def initialize(list)
    @counterparties = list.inject({}) { |acc, c| acc[c.name] = c; acc }
  end

  def find(name)
    @counterparties[name]
  end

  def output
    @counterparties.keys.sort
      .each {|name| puts find(name).balance }
  end
end
