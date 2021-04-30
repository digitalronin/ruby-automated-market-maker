#!/usr/bin/env ruby

require "./lib/amm"

ether, tokens = ARGV
ether ||= 10
tokens ||= 1000

amm = Amm.new(ether_reserve: ether.to_f, token_reserve: tokens.to_f)
string = ""

loop do
  print "> "
  string = STDIN.gets

  case string.chomp
  when /buy (.*)/
    amm.buy($1)
  when /sell (.*)/
    amm.sell($1)
  when "q"
    break
  else
    puts "???"
  end
end

puts "bye."
