require 'spec_helper'

module Sucker
  describe HashBuilder do
    let(:xml) do
      xml = <<-XML
      <?xml version=\"1.0\" ?>
      <ItemAttributes>
        <Title>Anti-Oedipus</Title>
        <Author>Gilles Deleuze</Author>
        <Author>Felix Guattari</Author>
        <Creator Role="Translator">Robert Hurley</Creator>
      </ItemAttributes>
      XML
      xml.gsub!(/>\s+</, '><')
      Nokogiri::XML(xml)
    end

    describe '.from_xml' do
      it 'returns a hash' do
        HashBuilder.from_xml(xml).should be_an_instance_of Hash
      end

      it 'handles only childs' do
        HashBuilder.from_xml(xml)['Title'].should eql 'Anti-Oedipus'
      end

      it 'handles arrays' do
        HashBuilder.from_xml(xml)['Author'].should be_a Array
      end

      it 'handles attributes' do
        node = HashBuilder.from_xml(xml)['Creator']
        node['Role'].should eql 'Translator'
        node['__content__'].should eql 'Robert Hurley'
      end
    end
  end
end
