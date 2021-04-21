#!/usr/bin/env ruby

class Amm
  attr_accessor :eth, :tokens, :konst

  def initialize(eth, tokens)
    @eth = eth.to_f
    @tokens = tokens.to_f
    @konst = eth * tokens
    output
  end

  # Uniswap V1
  # https://github.com/Uniswap/uniswap-v1/blob/c10c08d81d6114f694baa8bd32f555a40f6264da/contracts/uniswap_exchange.vy#L127
  #
  # def ethToTokenInput(eth_sold: uint256(wei), min_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
  #   assert deadline >= block.timestamp and (eth_sold > 0 and min_tokens > 0)
  #   token_reserve: uint256 = self.token.balanceOf(self)
  #   tokens_bought: uint256 = self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(self.balance - eth_sold), token_reserve)
  #   assert tokens_bought >= min_tokens
  #   assert self.token.transfer(recipient, tokens_bought)
  #   log.TokenPurchase(buyer, eth_sold, tokens_bought)
  #   return tokens_bought

  # Buy tokens for eth
  def buy(amount)
    ether = amount.to_f
    token_reserve = @tokens
    tokens_bought = get_input_price(ether, @eth - ether, token_reserve)
    puts "You get #{tokens_bought} tokens" # this is where we would transfer tokens to the buyer
    @tokens = token_reserve - tokens_bought
    @eth = @eth + ether
    output
  end

  # Sell tokens and return eth
  def sell(tkns)
    eth_amount = tkns.to_f * token_price
    new_token_balance = tokens + tkns.to_f
    new_eth_balance = eth - eth_amount

    puts "You get #{eth_amount} ETH" # This is where we send ETH to the seller

    @tokens = new_token_balance
    @eth = new_eth_balance

    output
  end

  private

  def output
    puts "Eth: #{eth}, tokens: #{tokens}, konst: #{konst}"
  end

  def token_price
    eth / tokens
  end

# @dev Pricing function for converting between ETH and Tokens.
# @param input_amount Amount of ETH or Tokens being sold.
# @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
# @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
# @return Amount of ETH or Tokens bought.
# @private
# @constant
# def getInputPrice(input_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
#     assert input_reserve > 0 and output_reserve > 0
#     input_amount_with_fee: uint256 = input_amount * 997
#     numerator: uint256 = input_amount_with_fee * output_reserve
#     denominator: uint256 = (input_reserve * 1000) + input_amount_with_fee
#     return numerator / denominator
# end

  def get_input_price(input_amount, eth_reserve, token_reserve)
    numerator = input_amount * token_reserve
    denominator = eth_reserve + input_amount
    return numerator / denominator
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
  when /sell (.*)/
    amm.sell($1)
  else
    puts "???"
  end
end

puts "bye."
