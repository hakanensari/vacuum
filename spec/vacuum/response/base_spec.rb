require 'spec_helper'

module Vacuum
  module Response
    describe Base do
      let(:body) do
        '<?xml version="1.0" ?>
          <children>
            <child>
              <name>foo</name>
            </child>
            <child>
              <name>bar</name>
            </child>
          </children>'.gsub />\s+</, '><'
      end

      let(:response) do
        described_class.new body, '200'
      end

      it_behaves_like 'a response'

      describe '#[]' do
        it 'returns an array of matches' do
          response.find('child').should_not be_empty
        end

        it 'yields matches to a block' do
          names = response.find('child') do |child|
            child['name']
          end
          names.should =~ %w(foo bar)
        end
      end

      describe '#xml_find' do
        it 'returns XML nodes instead of hashes' do
          response.xml_find('child').first.should be_kind_of Nokogiri::XML::Element
        end
      end
    end
  end
end
