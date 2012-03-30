shared_examples 'an MWS endpoint' do
  it_behaves_like 'an endpoint'

  describe '#host' do
    it 'returns a host' do
      endpoint.host.should match /amazon/
    end
  end

  describe '#marketplace' do
    it 'requires marketplace ID to have been set' do
      expect { endpoint.marketplace }.to raise_error Vacuum::MissingMarketplace
    end
  end

  describe '#seller' do
    it 'requires seller ID to have been set' do
      expect { endpoint.seller }.to raise_error Vacuum::MissingSeller
    end
  end
end
