#!/usr/bin/env ruby

require "./lib/amm"

amm = Amm.new(10, 1000)
string = ""

loop do
  print "> "
  string = gets

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
