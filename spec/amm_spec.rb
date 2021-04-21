describe Amm do
  let(:ether_reserve) { 10 }
  let(:token_reserve) { 1000 }

  subject(:amm) { described_class.new(ether_reserve, token_reserve) }

  it "sets eth value" do
    expect(amm.ether_reserve).to eq(ether_reserve)
  end

  it "sets tokens value" do
    expect(amm.token_reserve).to eq(token_reserve)
  end
end
