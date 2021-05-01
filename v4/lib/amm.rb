class Amm
  attr_accessor :ether_reserve, :token_reserve, :total_liquidity

  def initialize(params = {})
    @ether_reserve = 0.0
    @token_reserve = 0.0
    @total_liquidity = 0.0
    @silent = params.fetch(:silent) { false }
    output
  end

  def add_liquidity(ether, max_tokens)
    if @total_liquidity > 0.0
      # Adding more liquidity to existing AMM
      raise "We haven't implemented adding more liquidity yet"
    else
      # First deposit into AMM
      @token_reserve = max_tokens.to_f
      @ether_reserve = ether.to_f
      @konst = @token_reserve * @ether_reserve
      @total_liquidity = @ether_reserve # Use ether as our unit of account for liquidity tokens
      log "Add liquidity returning #{@total_liquidity} liquidity tokens"
      # TODO: Give liquidity tokens to liquidity provider
      output
      return @total_liquidity
    end
  end

  # Counterparty pays `amount` eth for some tokens
  def buy(counterparty, amount)
    ether = amount.to_f
    tokens_bought, @ether_reserve, @token_reserve = trade(ether, @ether_reserve, @token_reserve)
    price = sprintf("%0.4f", ether / tokens_bought)
    log "#{counterparty.name} gets #{tokens_bought} tokens for #{ether} ether, price #{price}"
    counterparty.ether -= ether
    counterparty.tokens += tokens_bought
    output
    return tokens_bought
  end

  # Counterparty sells `amount` tokens for some eth
  def sell(counterparty, amount)
    tokens = amount.to_f
    ether, @token_reserve, @ether_reserve = trade(tokens, @token_reserve, @ether_reserve)
    price = sprintf("%0.4f", ether / tokens)
    log "#{counterparty.name} gets #{ether} ether for #{tokens} tokens, price #{price}" # This is where we send ETH to the seller
    counterparty.ether += ether
    counterparty.tokens -= tokens
    output
    return ether
  end

  def output
    log "Amm eth: #{@ether_reserve}, tokens: #{@token_reserve}"
  end

  private

  def trade(amount, input_reserve, output_reserve)
    new_input_reserve = input_reserve + amount
    new_output_reserve = @konst / new_input_reserve
    proceeds = output_reserve - new_output_reserve
    return [proceeds, new_input_reserve, new_output_reserve]
  end

  def log(msg)
    return if @silent
    puts msg
  end
end
