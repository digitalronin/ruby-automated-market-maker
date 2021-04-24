#!/usr/bin/env ruby

require "./lib/amm"

ether, tokens = ARGV

amm = Amm.new(ether_reserve: ether.to_f, token_reserve: tokens.to_f)
string = ""

loop do
  print "> "
  string = STDIN.gets

  break if string.chomp == "q"

  case string
  when /buy (.*)/
    amm.buy($1)
  when /sell (.*)/
    amm.sell($1)
  else
    puts "???"
  end
end

puts "bye."
