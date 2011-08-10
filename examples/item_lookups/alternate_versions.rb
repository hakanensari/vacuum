require File.expand_path('../../helper.rb', __FILE__)

in_your_shell do
  req = AmazonProduct['us']

  req.configure do |c|
    c.key    = YOUR_AMAZON_KEY
    c.secret = YOUR_AMAZON_SECRET
    c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
  end

  # Look up the alternate versions of an ASIN.
  req.find('0679753354', :response_group => 'AlternateVersions')
end
