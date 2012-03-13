require 'spec_helper'

module Vacuum
  describe Response do
    let(:res) do
      body = File.read(File.expand_path('../../fixtures/http_response', __FILE__))
      Response.new(body, '200')
    end

    describe '#errors' do
      it 'returns an array of errors' do
        res.body =  <<-EOF.gsub!(/>\s+</, '><').strip!
        <?xml version=\"1.0\" ?>
        <Response xmlns="http://example.com">
          <Errors>
            <Error>foo</Error>
          </Errors>
        </Response>
        EOF

        res.errors.should =~ ['foo']
      end
    end

    describe '#find' do
      it 'returns an array of matching nodes' do
        res.find('ASIN').should_not be_empty
      end

      it 'yields matches to a block if given one' do
        titles = res.find('Item') { |item| item['ItemAttributes']['Title'] }
        titles.count.should eql 2
        titles.each { |title| title.should be_a String }
      end
    end

    describe '#has_errors?' do
      context 'when response does not contain any errors' do
        it 'returns false' do
          res.stub!(:errors).and_return([])
          res.should_not have_errors
        end
      end

      context 'when response contains errors' do
        it 'returns true' do
          res.stub!(:errors).and_return([1])
          res.should have_errors
        end
      end
    end

    describe '#to_hash' do
      it 'casts response to a hash' do
        res.to_hash.should be_a Hash
      end
    end

    describe '#valid?' do
      context 'when HTTP status is OK' do
        it 'returns true' do
          res.should be_valid
        end
      end

      context 'when HTTP status is not OK' do
        it 'returns false' do
          res.code = 403
          res.should_not be_valid
        end
      end
    end

    describe '#xml' do
      it 'returns a Nokogiri document' do
        res.xml.should be_an_instance_of Nokogiri::XML::Document
      end
    end
  end
end
