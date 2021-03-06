describe Amm do
  let(:ether_reserve) { 10 }
  let(:token_reserve) { 1000 }

  let(:params) { {
    ether_reserve: ether_reserve,
    token_reserve: token_reserve,
    silent: true,
  } }

  let(:initial_eth) { 10.0 }
  let(:alice) { Counterparty.new(name: "alice", ether: initial_eth) }

  subject(:amm) { described_class.new(params) }

  it "sets eth value" do
    expect(amm.ether_reserve).to eq(ether_reserve)
  end

  it "sets tokens value" do
    expect(amm.token_reserve).to eq(token_reserve)
  end

  it "returns to initial state" do
    tokens = amm.buy(alice, 1)
    amm.sell(alice, tokens)

    actual = {
      ether_reserve: amm.ether_reserve,
      token_reserve: amm.token_reserve,
    }

    expected = {
      ether_reserve: params[:ether_reserve],
      token_reserve: params[:token_reserve],
    }

    expect(actual).to eq(expected)
  end

  it "increases token price" do
    tokens1 = amm.buy(alice, 1)
    tokens2 = amm.buy(alice, 1)

    expect(tokens1).to be > tokens2
  end

  it "reduces token price" do
    tokens = amm.buy(alice, 1)

    eth1 = amm.sell(alice, tokens/2)
    eth2 = amm.sell(alice, tokens/2)

    expect(eth1).to be > eth2
  end

  it "takes ether from counterparty" do
    amm.buy(alice, 1)
    expect(alice.ether).to eq(initial_eth - 1)
  end

  it "gives tokens to counterparty" do
    amm.buy(alice, 1)
    expect(alice.tokens).to be > 0
  end

  it "takes tokens from counterparty" do
    amm.buy(alice, 1)
    t1 = alice.tokens

    amm.sell(alice, 1)
    expect(alice.tokens).to eq(t1 - 1)
  end
end
