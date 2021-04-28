#!/usr/bin/env ruby

require "./lib/requires"

ether, tokens = ARGV
ether ||= 10
tokens ||= 1000

amm = Amm.new(ether_reserve: ether.to_f, token_reserve: tokens.to_f)
string = ""

loop do
  print "> "
  string = STDIN.gets

  break if string.chomp == "q"

  case string
  when /(.*) buy (.*)/
    name = $1
    ether = $2.to_f
    amm.buy(name, ether)
  when /(.*) sell (.*)/
    name = $1
    tokens = $2.to_f
    amm.sell(name, tokens)
  else
    puts "???"
  end
end

puts "bye."
