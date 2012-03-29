shared_examples 'an endpoint' do
  describe '#key' do
    it 'requires key to have been set' do
      expect { endpoint.key }.to raise_error Vacuum::MissingKey
    end
  end

  describe '#locale' do
    it 'defaults to the US' do
      endpoint.locale.should eql 'US'
    end

    context 'if not valid' do
      before do
        endpoint.locale = 'foo'
      end

      it 'raises an error' do
        expect { endpoint.locale }.to raise_error Vacuum::BadLocale
      end
    end
  end

  describe '#secret' do
    it 'requires secret to have been set' do
      expect { endpoint.secret }.to raise_error Vacuum::MissingSecret
    end
  end
end
