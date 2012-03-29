module Vacuum
  module Response
    module Utils
      # Builds a Hash from an XML document.
      #
      # xml - a Nokogiri::XML::Document or Nokogiri::XML::Element.
      #
      # Returns a Hash representation of the XML document.
      def self.xml_to_hash(xml)
        case xml
        when Nokogiri::XML::Document
          xml_to_hash xml.root
        when Nokogiri::XML::Element
          hsh = {}

          xml.attributes.each_pair do |key, attribute|
            hsh[key] = attribute.value
          end

          xml.children.each do |child|
            result = xml_to_hash child

            if child.name == 'text'
              if hsh.empty?
                return result
              else
                hsh['__content__'] = result
              end
            elsif hsh[child.name]
              case hsh[child.name]
              when Array
                hsh[child.name] << result
              else
                hsh[child.name] = [hsh[child.name]] << result
              end
            else
              hsh[child.name] = result
            end
          end

          hsh
        else
          xml.content.to_s
        end
      end
    end
  end
end
