require File.expand_path('../shared.rb', __FILE__)
require 'structure'

class Item < Structure
  # Monkey patch to massage the Amazon hash.
  def marshal_load(hsh)
    hsh.each do |k, v|
      # Get rid of redundant nestings.
      if v.is_a?(Hash) && v.keys.size == 1
        v = v.values.first if k.match(/^#{v.keys.first}/)
      end

      # Undersore camelcased keys.
      k = k.scan(/[A-Z](?:[A-Z]+|[a-z]+)|\d/).
            flatten.map(&:downcase).join("_")

      self.send("#{new_field(k)}=", v)
    end
  end
end

module Vacuum
  module Request
    class ProductAdvertising
      def search(search_index, parameters = nil)
        if parameters.nil?
          parameters = { 'Keywords' => search_index }
          search_index  = 'All'
        end

        if parameters.is_a? String
          parameters = { 'Keywords' => parameters }
        end

        build!({ 'Operation'   => 'ItemSearch',
                 'SearchIndex' => search_index }.merge(parameters))

        get.items
      end
    end
  end

  module Response
    class ProductAdvertising
      def items
        find('Item') { |item| Item.new(item) }
      end
    end
  end
end

req = Vacuum.new(:product_advertising) do |config|
  config.key    = KEY
  config.secret = SECRET
  config.tag    = TAG
end
items = req.search 'deleuze'

binding.pry
