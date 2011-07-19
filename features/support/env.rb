require 'rubygems'
require 'bundler/setup'
require 'digest/md5'
require 'sucker'

module SuckerMethods
  def amazon_key
    ENV['AMAZON_KEY'] || "key"
  end

  def amazon_secret
    ENV['AMAZON_SECRET'] || "secret"
  end

  def cassette_name
    params = @request.parameters.normalize
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
