describe Amm do
  let(:ether_reserve) { 10 }
  let(:token_reserve) { 1000 }

  let(:params) { {
    ether_reserve: ether_reserve,
    token_reserve: token_reserve,
    silent: true,
  } }

  subject(:amm) { described_class.new(params) }

  it "sets eth value" do
    expect(amm.ether_reserve).to eq(ether_reserve)
  end

  it "sets tokens value" do
    expect(amm.token_reserve).to eq(token_reserve)
  end
end