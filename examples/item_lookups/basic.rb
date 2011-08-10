require File.expand_path('../../helper.rb', __FILE__)

in_your_shell do
  req = AmazonProduct['us']

  req.configure do |c|
    c.key    = YOUR_AMAZON_KEY
    c.secret = YOUR_AMAZON_SECRET
    c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
  end

  req.find('0816614024')
end
