describe Amm do
  let(:ether_reserve) { 10 }
  let(:token_reserve) { 1000 }

  let(:initial_eth) { 10.0 }
  let(:alice) { Counterparty.new(name: "alice", ether: initial_eth) }

  let(:lp) { Counterparty.new(name: "liquidity provider", ether: initial_eth, tokens: token_reserve) }

  subject(:amm) { described_class.new(silent: true) }

  context "Adding initial liquidity" do
    it "starts with no ether" do
      expect(amm.ether_reserve).to eq(0.0)
    end

    it "starts with no tokens" do
      expect(amm.token_reserve).to eq(0.0)
    end

    it "adds ether and tokens" do
      amm.add_liquidity(lp, 5, 500)
      expect([amm.ether_reserve, amm.token_reserve]).to eq([5, 500])
    end

    xit "returns liquidity tokens minted" do
      lp_tokens = amm.add_liquidity(lp, 5, 500)
      expect(lp_tokens).to eq(5.0)
    end
  end

  context "With initial liquidity" do
    before do
      amm.add_liquidity(lp, ether_reserve, token_reserve)
    end

    it "does not change price when adding liquidity" do
      price = amm.get_price
      amm.add_liquidity(lp, 5, 500)
      expect(amm.get_price).to eq(price)
    end

    it "takes ether from provider" do
      expect {
        amm.add_liquidity(lp, 5, 500)
      }.to change(lp, :ether).by(-5)
    end

    it "takes tokens from provider" do
      expect {
        amm.add_liquidity(lp, 5, 500)
      }.to change(lp, :tokens).by(-500)
    end

    it "removes ether" do
      amm.add_liquidity(lp, 5, 500)
      expect {
        amm.remove_liquidity(lp, 1)
      }.to change(amm, :ether_reserve).by(-1)
    end

    it "removes tokens" do
      amm.add_liquidity(lp, 5, 500)
      expect {
        amm.remove_liquidity(lp, 1)
      }.to change(amm, :token_reserve).by(-100)
    end

    it "returns ether to provider" do
      amm.add_liquidity(lp, 5, 500)
      expect {
        amm.remove_liquidity(lp, 1)
      }.to change(lp, :ether).by(1)
    end

    it "returns tokens to provider" do
      amm.add_liquidity(lp, 5, 500)
      expect {
        amm.remove_liquidity(lp, 1)
      }.to change(lp, :tokens).by(100)
    end

    it "cannot remove too much ether"

    it "sets eth value" do
      expect(amm.ether_reserve).to eq(ether_reserve)
    end

    it "sets tokens value" do
      expect(amm.token_reserve).to eq(token_reserve)
    end

    it "returns token price" do
      expect(amm.get_price).to eq(0.01)
    end

    it "has higher token price after buy" do
      initial_price = amm.get_price
      amm.buy(alice, 1)
      expect(amm.get_price).to be > initial_price
    end

    it "has lower token price after sell" do
      initial_price = amm.get_price
      amm.sell(alice, 100)
      expect(amm.get_price).to be < initial_price
    end

    it "returns to initial state" do
      tokens = amm.buy(alice, 1)
      amm.sell(alice, tokens)

      actual = {
        ether_reserve: amm.ether_reserve,
        token_reserve: amm.token_reserve,
      }

      expected = {
        ether_reserve: ether_reserve,
        token_reserve: token_reserve,
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
end
