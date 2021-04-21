class Amm
  attr_accessor :ether_reserve, :token_reserve

  def initialize(params)
    @ether_reserve = params.fetch(:ether_reserve).to_f
    @token_reserve = params.fetch(:token_reserve).to_f
    @silent = params.fetch(:silent) { false }
    output
  end

  # Counterparty pays `amount` eth for some tokens
  def buy(amount)
    ether = amount.to_f

    konst = @ether_reserve * @token_reserve
    @ether_reserve += ether
    new_token_reserve = konst / @ether_reserve

    tokens_bought = @token_reserve - new_token_reserve
    log "You get #{tokens_bought} tokens" # this is where we would transfer tokens to the buyer

    @token_reserve = new_token_reserve
    output
  end

  # Counterparty sells `amount` tokens for some eth
  def sell(amount)
    tokens_sold = amount.to_f

    konst = @ether_reserve * @token_reserve
    @token_reserve += tokens_sold
    new_ether_reserve = konst / @token_reserve

    ether = @ether_reserve - new_ether_reserve
    log "You get #{ether} ether" # This is where we send ETH to the seller

    @ether_reserve = new_ether_reserve
    output
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
