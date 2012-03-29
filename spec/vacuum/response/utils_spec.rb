require 'spec_helper'

module Vacuum
  module Response
    describe Utils do
      describe '.xml_to_hash' do
        let(:hash) do
          str = <<-XML.gsub!(/>\s+</, '><').strip!
          <?xml version=\"1.0\" ?>
          <ItemAttributes>
            <Title>Anti-Oedipus</Title>
            <Author>Gilles Deleuze</Author>
            <Author>Felix Guattari</Author>
            <Creator Role="Translator">Robert Hurley</Creator>
          </ItemAttributes>
          XML
          xml = Nokogiri::XML.parse str

          Utils.xml_to_hash xml
        end

        it 'returns a hash' do
          hash.should be_an_instance_of Hash
        end

        it 'handles only childs' do
          hash['Title'].should eql 'Anti-Oedipus'
        end

        it 'handles arrays' do
          hash['Author'].should be_a Array
        end

        it 'handles attributes' do
          node = hash['Creator']
          node['Role'].should eql 'Translator'
          node['__content__'].should eql 'Robert Hurley'
        end
      end
    end
  end
end
