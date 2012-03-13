require File.expand_path('../helper.rb', __FILE__)
require 'structure'
require 'vacuum'

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
  class Request
    def search(search_index, params = nil)
      if params.nil?
        params = { 'Keywords' => search_index }
        search_index  = 'All'
      end

      if params.is_a? String
        params = { 'Keywords' => params }
      end

      build!({ 'Operation'   => 'ItemSearch',
               'SearchIndex' => search_index }.merge(params))

      get.items
    end
  end

  class Response
    def items
      find('Item') { |item| Item.new(item) }
    end
  end
end

req = Vacuum.new :key    => KEY,
                 :secret => SECRET,
                 :tag    => TAG

items = req.search('deleuze')

binding.pry
