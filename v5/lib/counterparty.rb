class Counterparty
  attr_accessor :name, :ether, :tokens, :lp_tokens

  def initialize(params)
    @name = params.fetch(:name)
    @ether = params.fetch(:ether, 0).to_f
    @tokens = params.fetch(:tokens, 0).to_f
    @lp_tokens = params.fetch(:lp_tokens, 0).to_f
  end

  def balance
    eth = sprintf("%0.4f", ether)
    tkns = sprintf("%0.4f", tokens)
    lp = sprintf("%0.4f", lp_tokens)

    "#{name}\tether: #{eth},\ttokens: #{tkns}, lp_tokens: #{lp}"
  end
end
