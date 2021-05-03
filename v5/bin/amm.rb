#!/usr/bin/env ruby

require "./lib/requires"

amm = Amm.new

alice = Counterparty.new(name: "alice", ether: 10)
bob = Counterparty.new(name: "bob", ether: 10)
zoe = Counterparty.new(name: "zoe", ether: 10, tokens: 1000)

counterparties = Counterparties.new([alice, bob, zoe])

loop do
  print "> "
  string = STDIN.gets

  case string.chomp
  when /(.*) buy (.*)/
    counterparty = counterparties.find($1)
    ether = $2.to_f
    amm.buy(counterparty, ether)
  when /(.*) sell (.*)/
    counterparty = counterparties.find($1)
    tokens = $2 == "all" ? counterparty.tokens : $2.to_f
    amm.sell(counterparty, tokens)
  when /(.*) add_liquidity (.*) (.*)/, /(.*) add (.*) (.*)/
    counterparty = counterparties.find($1)
    amm.add_liquidity(counterparty, $2.to_f, $3.to_f)
  when /(.*) remove_liquidity (.*)/, /(.*) remove (.*)/
    counterparty = counterparties.find($1)
    amm.remove_liquidity(counterparty, $2.to_f)
  when "counterparties", "c"
    counterparties.output
    amm.output
  when "q"
    break
  else
    puts "???"
  end
end

puts "bye."
