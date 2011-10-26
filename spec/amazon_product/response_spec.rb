require 'spec_helper'

module AmazonProduct
  describe Response do
    let(:resp) do
      body = File.read(File.expand_path('../../fixtures/http_response', __FILE__))
      code = '200'
      Response.new(body, code)
    end

    describe '#each' do
      it 'yields matches to given block' do
        yielded = false
        resp.each('Item') do |item|
          yielded = true
        end

        yielded.should be_true
      end
    end

    describe '#errors' do
      it 'returns an array of errors' do
        resp.body =  <<-EOF.gsub!(/>\s+</, '><').strip!
        <?xml version=\"1.0\" ?>
        <resp xmlns="http://example.com">
          <Errors>
            <Error>foo</Error>
          </Errors>
        </resp>
        EOF

        resp.errors.should =~ ['foo']
      end
    end

    describe '#has_errors?' do
      context 'when a resp does not contain any errors' do
        it 'returns false' do
          resp.stub!(:errors).and_return([])

          resp.should_not have_errors
        end
      end

      context 'when a resp contains errors' do
        it 'returns true' do
          resp.stub!(:errors).and_return([1])

          resp.should have_errors
        end
      end
    end

    describe '#find' do
      it 'returns an array of matching nodes' do
        resp.find('ASIN').should_not be_empty
      end
    end

    describe "#map" do
      it "yields each match to a block and maps returned values" do
        titles = resp.map('Item') { |i| i['ItemAttributes']['Title'] }

        titles.count.should eql 2
      end
    end

    describe '#to_hash' do
      it 'casts resp to a hash' do
        resp.to_hash.should be_a Hash
      end
    end

    describe '#valid?' do
      context 'when HTTP status is OK' do
        it 'returns true' do
          resp.should be_valid
        end
      end

      context 'when HTTP status is not OK' do
        it 'returns false' do
          resp.code = 403
          resp.should_not be_valid
        end
      end
    end

    describe '#xml' do
      it 'returns a Nokogiri document' do
        resp.xml.should be_an_instance_of Nokogiri::XML::Document
      end
    end
  end
end
