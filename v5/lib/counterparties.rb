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
      .each {|name| puts show_balance(name) }
  end

  private

  def show_balance(name)
    c = find(name)
    ether = sprintf("%0.4f", c.ether)
    tokens = sprintf("%0.4f", c.tokens)
    "#{name}\tether: #{ether},\ttokens: #{tokens}"
  end
end
