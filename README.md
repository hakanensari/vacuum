Sucker
======

Sucker is a Nokogiri-based, optionally-evented Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

Caption: Workers queuing to download data from Amazon.

Usage
-----

Read the [Amazon API](http://aws.amazon.com/archives/Product%20Advertising%20API).
Check out [these examples](http://relishapp.com/papercavalier/sucker) if in a hurry.

Set up.

```ruby
request = Sucker.new(
  :locale => :us,
  :key    => amazon_key,
  :secret => amazon_secret)
```

Build a request.

```ruby
request << {
  'Operation'     => 'ItemLookup',
  'IdType'        => 'ASIN',
  'ItemId'        => 10.asins,
  'ResponseGroup' => 'ItemAttributes' }
```

Get a response.

```ruby
response = request.get
```

Fulfill a business value.

```ruby
if response.valid?
  response.each('Item') do |item|
    consume(item)
  end
end
```

Repeat ad infinitum.

The following are all valid ways to query a response:

```ruby
items = response.find('Item')
items = response['Item']
items = response.map('Item') { |item| ... }
response.each('Item') { |item| ... }
```

To dig further into the response object:

```ruby
p response.valid?,
  response.body,
  response.code,
  response.errors,
  response.has_errors?,
  response.to_hash,
  response.xml
```

To use multiple local IPs on your server, configure the request adapter:

```ruby
adapter = request.adapter
adapter.socket_local.host = '10.0.0.2'
```

[Browse the public interface of Sucker.](http://rdoc.info/github/papercavalier/sucker/master/frames)

Evented Requests
----------------

I am including a EM:Synchrony patch in the 2.0 release.

```ruby
require 'sucker/synchrony'

EM.synchrony do
  # set up request
  response = request.get
  # do something with the response
  EM.stop
end

For more meaningful examples, read [these examples](http://relishapp.com/papercavalier/sucker/evented-requests).
```

Stubbing Tests
--------------

Try [VCR](http://github.com/myronmarston/vcr).

Moral of the story
------------------

Don't overabstract a spaghetti API.
