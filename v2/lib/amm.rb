class Amm
  attr_accessor :ether_reserve, :token_reserve

  def initialize(params)
    @ether_reserve = params.fetch(:ether_reserve).to_f
    @token_reserve = params.fetch(:token_reserve).to_f
    @silent = params.fetch(:silent) { false }

    @konst = @ether_reserve * @token_reserve
    output
  end

  # Counterparty pays `amount` eth for some tokens
  def buy(amount)
    ether = amount.to_f
    tokens_bought, @ether_reserve, @token_reserve = trade(ether, @ether_reserve, @token_reserve)
    price = sprintf("%0.4f", ether / tokens_bought)
    log "You get #{tokens_bought} tokens for #{ether} ether, price #{price}" # this is where we would transfer tokens to the buyer
    output
    return tokens_bought
  end

  # Counterparty sells `amount` tokens for some eth
  def sell(amount)
    tokens = amount.to_f
    ether, @token_reserve, @ether_reserve = trade(tokens, @token_reserve, @ether_reserve)
    price = sprintf("%0.4f", ether / tokens)
    log "You get #{ether} ether for #{tokens} tokens, price #{price}" # This is where we send ETH to the seller
    output
    return ether
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

  def output
    log "Pool eth: #{@ether_reserve}, tokens: #{@token_reserve}"
  end
end
