require File.expand_path('../../helper.rb', __FILE__)
require 'structure'

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

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

class Vacuum::Response
  def to_items
    find('Item').map { |hsh| Item.new(hsh) }
  end
end

items = req.search('deleuze').to_items

binding.pry
