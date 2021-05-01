#!/usr/bin/env ruby

require "./lib/requires"

amm = Amm.new

alice = Counterparty.new(name: "alice", ether: 10)
bob = Counterparty.new(name: "bob", ether: 10)

counterparties = Counterparties.new([alice, bob])

loop do
  print "> "
  string = STDIN.gets

  case string.chomp
  when /(.*) buy (.*)/
    name = $1
    ether = $2.to_f
    counterparty = counterparties.find(name)
    amm.buy(counterparty, ether)
  when /(.*) sell (.*)/
    name = $1
    counterparty = counterparties.find(name)
    tokens = $2 == "all" ? counterparty.tokens : $2.to_f
    amm.sell(counterparty, tokens)
  when /add_liquidity (.*) (.*)/
    amm.add_liquidity($1.to_f, $2.to_f)
  when "counterparties"
    counterparties.output
  when "q"
    break
  else
    puts "???"
  end
end

puts "bye."
