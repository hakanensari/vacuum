module AmazonProduct
  module Builder
    # Builds a hash from a Nokogiri XML document
    #
    # @note In earlier versions of the library, I was relying on the
    # XML Mini Nokogiri module in Active Support. This method
    # essentially accomplishes the same.
    #
    # @see Based on https://gist.github.com/335286
    #
    # @param [Nokogiri::XML::Document] xml an XML document
    # @return [Hash] a hashified version of the XML document
    def self.from_xml(xml)
      case xml
      when Nokogiri::XML::Document
        from_xml(xml.root)
      when Nokogiri::XML::Element
        hsh = {}

        xml.attributes.each_pair do |key, attr|
          hsh[key] = attr.value
        end

        xml.children.each do |child|
          result = from_xml(child)

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
