require 'rubygems'
require 'bundler/setup'
require 'digest/md5'
require 'ruby-debug'
require 'sucker'

module SuckerMethods
  def amazon
    YAML::load_file(File.dirname(__FILE__) + "/../../spec/support/amazon.yml")
  end

  def amazon_key
    amazon['key']
  end

  def amazon_secret
    amazon['secret']
  end

  def cassette_name
    params = @worker.parameters.normalize
    params.delete('Timestamp')
    params['Operation'].downcase + '/' + Digest::MD5.hexdigest(params.to_json)
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
