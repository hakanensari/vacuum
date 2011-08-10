require 'spec_helper'

module AmazonProduct
  describe Response do
    let(:response) do
      http_resp = Struct.new(:body, :code).new
      http_resp.body = File.read(File.expand_path('../../fixtures/http_response', __FILE__))
      http_resp.code = '200'
      Response.new(http_resp)
    end

    describe '#each' do
      context 'when a block is given' do
        it 'yields matches to a block' do
          yielded = false
          response.each('Item') do |item|
            yielded = true
          end

          yielded.should be_true
        end
      end
    end

    describe '#errors' do
      it 'returns an array of errors' do
        response.body =  <<-XML.gsub!(/>\s+</, '><').strip!
        <?xml version=\"1.0\" ?>
        <Response xmlns="http://example.com">
          <Errors>
            <Error>foo</Error>
          </Errors>
        </Response>
        XML
        response.errors.should =~ ['foo']
      end
    end

    describe '#has_errors?' do
      context 'when a response does not contain any errors' do
        it 'returns false' do
          response.stub!(:errors).and_return([])
          response.should_not have_errors
        end
      end

      context 'when a response contains errors' do
        it 'returns true' do
          response.stub!(:errors).and_return([1])
          response.should have_errors
        end
      end
    end

    describe '#find' do
      it 'returns an array of matching nodes' do
        response.find('ASIN').should_not be_empty
      end
    end

    describe "#map" do
      it "yields each match to a block and maps returned values" do
        titles = response.map('Item') { |item| item['ItemAttributes']['Title'] }
        titles.count.should eql 2
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
        it 'returns false' do
          response.code = 403
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
end
