def amazon_associate_tag
  ENV['AMAZON_ASSOCIATE_TAG'] || "tag"
end

def amazon_key
  ENV['AMAZON_KEY'] || "key"
end

def amazon_secret
  ENV['AMAZON_SECRET'] || "secret"
end
