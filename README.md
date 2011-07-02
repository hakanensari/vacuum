# Sucker

Sucker is a Nokogiri-based, optionally-evented Ruby wrapper to the
[Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

> Workers queuing to download data from Amazon.

## Usage

_Note_: For the README of version 1.6.1 and earlier, [click here](https://github.com/papercavalier/sucker/tree/v1.6.1).

1.  Define your Amazon credentials.

    ```ruby
    Sucker.configure do |c|
      c.locale        = :us
      c.key           = amazon_key
      c.secret        = amazon_secret
      c.associate_tag = associate_tag
    end

2.  Set up a request.

    ```ruby
    request = Sucker.new
    ```

    Alternatively, you may your credentials when initializing the request.

    ```ruby
    request = Sucker.new(
      :locale => :us,
      :key    => amazon_key,
      :secret => amazon_secret)
    end
    ```

2.  Build a request.

    ```ruby
    request << {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ItemId'        => 10.asins,
      'ResponseGroup' => 'ItemAttributes' }
    ```

    Amazon provides countless configuration options to fine-tune your query. Read
    [their API](http://aws.amazon.com/archives/Product%20Advertising%20API) or 
    check out [these common scenarios](http://relishapp.com/papercavalier/sucker)
    if in a hurry.

3.  Get a response.

    ```ruby
    response = request.get
    ```

    Fulfill a business value.

    ```ruby
    if response.valid?
      response.find('Item').each do |item|
        # consume
      end
    end
    ```

4.  Repeat ad infinitum.

    ```ruby
    request << { 'ItemId' => 10.new.asins }
    request.get["Item"].each do |item|
      # consume
    end
    ```


## Some tips

Inspect the response as a hash to find out nodes you are interested in.

```ruby
p response.to_hash
```

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

Large responses can block! I am including an EM:Synchrony patch in the 2.0
release.

```ruby
require 'sucker/synchrony'

EM.synchrony do
  # set up request
  response = request.get
  # do something with the response
  EM.stop
end

```
For more meaningful examples, read [here](http://relishapp.com/papercavalier/sucker/evented-requests).

Stubbing Tests
--------------

Try [VCR](http://github.com/myronmarston/vcr).

Moral of the story
------------------

Don't overabstract a spaghetti API.
