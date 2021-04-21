#!/usr/bin/env ruby

class Amm
  attr_accessor :eth, :tokens, :konst

  def initialize(eth, tokens)
    @eth = eth.to_f
    @tokens = tokens.to_f
    @konst = eth * tokens
    output
  end

  # Buy tokens for eth
  def buy(ether)
    sold = ether.to_f / token_price

    new_eth_balance = eth + ether.to_f
    new_token_balance = tokens - sold

    puts "You get #{sold} tokens"

    @tokens = new_token_balance
    @eth = new_eth_balance

    output
  end

  private

  def output
    puts "Eth: #{eth}, tokens: #{tokens}, price: #{token_price}, konst: #{konst}"
  end

  def token_price
    eth / tokens
  end
end

amm = Amm.new(10, 1000)
string = ""

loop do
  print "> "
  string = gets

  break if string.chomp == "q"

  case string
  when /buy (.*)/
    amm.buy($1)
  else
    puts "???"
  end
end

puts "bye."
