class Counterparty
  attr_accessor :name, :ether, :tokens

  def initialize(params)
    @name = params.fetch(:name)
    @ether = params.fetch(:ether, 0).to_f
    @tokens = params.fetch(:tokens, 0).to_f
  end
end
