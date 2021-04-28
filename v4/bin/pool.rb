#!/usr/bin/env ruby

require "./lib/requires"

ether, tokens = ARGV
ether ||= 10
tokens ||= 1000

amm = Pool.new(ether_reserve: ether.to_f, token_reserve: tokens.to_f)
string = ""

alice = Counterparty.new(name: "Alice", ether: 10)
bob = Counterparty.new(name: "Bob", ether: 10)

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
  when "counterparties"
    counterparties.output
  when "q"
    break
  else
    puts "???"
  end
end

puts "bye."
