require 'rubygems'
require 'bundler/setup'
require 'sucker'

module SuckerMethods
  def amazon
    YAML::load_file(File.dirname(__FILE__) + "/../../spec/support/amazon.yml")
  end

  def recursive_find_by_key(hash, key)
    stack = [hash]
    while hash = stack.pop
      hash.each do |k, v|
        return v if k == key
        stack << v if v.is_a? Hash
      end
    end
  end
end

World(SuckerMethods)
