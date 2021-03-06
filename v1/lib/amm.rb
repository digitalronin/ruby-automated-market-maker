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

    @ether_reserve += ether
    new_token_reserve = @konst / @ether_reserve

    tokens_bought = @token_reserve - new_token_reserve
    price = sprintf("%0.4f", ether / tokens_bought)
    log "You get #{tokens_bought} tokens for #{ether} ether, price #{price}" # this is where we would transfer tokens to the buyer

    @token_reserve = new_token_reserve
    output

    return tokens_bought
  end

  # Counterparty sells `amount` tokens for some eth
  def sell(amount)
    tokens_sold = amount.to_f

    @token_reserve += tokens_sold
    new_ether_reserve = @konst / @token_reserve

    ether = @ether_reserve - new_ether_reserve
    price = sprintf("%0.4f", ether / tokens_sold)
    log "You get #{ether} ether for #{tokens_sold} tokens, price #{price}" # This is where we send ETH to the seller

    @ether_reserve = new_ether_reserve
    output

    return ether
  end

  private

  def log(msg)
    return if @silent
    puts msg
  end

  def output
    log "Pool eth: #{@ether_reserve}, tokens: #{@token_reserve}"
  end
end
