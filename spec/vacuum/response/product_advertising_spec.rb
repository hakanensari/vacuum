require 'spec_helper'

module Vacuum
  module Response
    describe ProductAdvertising do
      let(:response) do
        path = File.expand_path('../../../fixtures/product_advertising', __FILE__)
        body = File.read path

        described_class.new body, '200'
      end

      it_behaves_like 'a response'

      context 'when Amazon returns errors' do
        before do
          response.body =  <<-EOF.gsub!(/>\s+</, '><').strip!
          <?xml version=\"1.0\" ?>
          <Response xmlns="http://example.com">
            <Errors>
              <Error>foo</Error>
            </Errors>
          </Response>
          EOF
        end

        describe '#errors' do
          it 'returns an Array of errors' do
            response.errors.should =~ ['foo']
          end
        end
      end

      describe '#has_errors?' do
        context 'when response does not contain any errors' do
          before do
            response.stub!(:errors).and_return([])
          end

          it 'returns false' do
            response.should_not have_errors
          end
        end

        context 'when response contains errors' do
          before do
            response.stub!(:errors).and_return([1])
          end

          it 'returns true' do
            response.should have_errors
          end
        end
      end
    end
  end
end
