class Amm
  attr_accessor :ether_reserve, :token_reserve

  def initialize(params = {})
    @ether_reserve = 0.0
    @token_reserve = 0.0
    @silent = params.fetch(:silent) { false }
    output
  end

  def get_price
    @ether_reserve.to_f / @token_reserve
  end

  def remove_liquidity(counterparty, ether)
    tokens_removed = ether * (@token_reserve / @ether_reserve)

    if ether > @ether_reserve
      log "Error: insufficient liquidity"
    else
      @token_reserve -= tokens_removed
      @ether_reserve -= ether

      counterparty.tokens += tokens_removed
      counterparty.ether += ether
    end

    output
  end

  def add_liquidity(counterparty, ether, max_tokens)
    tokens_added = 0.0

    if @ether_reserve > 0.0
      # Adding more liquidity to existing AMM
      tokens_added = ether * (@token_reserve / @ether_reserve)
    else
      # First deposit into AMM
      tokens_added = max_tokens
    end

    if tokens_added > max_tokens
      log "Error: #{max_tokens} is not enough. #{tokens_added} required."
    else
      @token_reserve += tokens_added
      @ether_reserve += ether

      counterparty.tokens -= tokens_added
      counterparty.ether -= ether
    end

    output
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
    log "Amm eth: #{@ether_reserve}, tokens: #{@token_reserve}, price: #{get_price} eth/token"
  end

  private

  def trade(amount, input_reserve, output_reserve)
    konst = @token_reserve * @ether_reserve

    new_input_reserve = input_reserve + amount
    new_output_reserve = konst / new_input_reserve
    proceeds = output_reserve - new_output_reserve
    return [proceeds, new_input_reserve, new_output_reserve]
  end

  def log(msg)
    return if @silent
    puts msg
  end
end
