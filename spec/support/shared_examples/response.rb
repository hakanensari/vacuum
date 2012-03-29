shared_examples 'a response' do
  let(:child_name) do
    response.xml.children.first.name
  end

  describe '#find' do
    it 'returns an Array of matches' do
      response.find(child_name).should_not be_empty
    end

    it 'yields matches to a block' do
      yielded = false
      response.find(child_name) { yielded = true }
      yielded.should be_true
    end

    it 'is aliased to []' do
      response.find(child_name).should eql response[child_name]
    end
  end

  describe '#to_hash' do
    it 'casts response to a hash' do
      response.to_hash.should be_a Hash
    end
  end

  describe '#valid?' do
    context 'when HTTP status is OK' do
      it 'returns true' do
        response.should be_valid
      end
    end

    context 'when HTTP status is not OK' do
      before do
        response.code = 403
      end

      it 'returns false' do
        response.should_not be_valid
      end
    end
  end

  describe '#xml' do
    it 'returns a Nokogiri document' do
      response.xml.should be_an_instance_of Nokogiri::XML::Document
    end
  end
end
