# Vacuum
[![Travis](https://travis-ci.org/hakanensari/vacuum.svg)](https://travis-ci.org/hakanensari/vacuum)

Vacuum is a fast, light-weight Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html).

![vacuum](http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png)

## Usage

### Prerequisite

Your Access Id must be registered for the Amazon Product Advertising API. Use the AccessKey Id obtained after registering at [https://affiliate-program.amazon.com/gp/flex/advertising/api/sign-in.html](https://affiliate-program.amazon.com/gp/flex/advertising/api/sign-in.html)

### Setup

Create a request:

```ruby
request = Vacuum.new
```

The locale will default to the US. To use another locale, reference its two-letter country code:

```ruby
request = Vacuum.new('GB')
```

Configure the request credentials:

```ruby
request.configure(
    aws_access_key_id: 'key',
    aws_secret_access_key: 'secret',
    associate_tag: 'tag'
)
```

You can omit the above if you set your key and secret as environment variables:

```sh
export AWS_ACCESS_KEY_ID=key
export AWS_SECRET_ACCESS_KEY=secret
```

You will still need to set an associate tag:

```ruby
request.associate_tag = 'tag'
```

Provided you are looking to earn commission, you have to register independently with each locale you query. Otherwise, you may reuse any dummy associate tag.

The API version defaults to `2013-08-01`. To use another version, reference its date string:

```ruby
request.version = '2011-08-01'
```

### Request

#### Browse Node Lookup

**BrowseNodeLookup** returns a specified browse node’s name and ancestors:

```ruby
response = request.browse_node_lookup(
  query: {
    'BrowseNodeId' => 123
  }
)
```

#### Cart Operations

The **CartCreate** operation creates a remote shopping cart:

```ruby
response = request.cart_create(
  query: {
    'HMAC' => 'secret',
    'Item.1.OfferListingId' => '123',
    'Item.1.Quantity' => 1
  }
)
```

The **CartAdd** operation adds items to an existing remote shopping cart:

```ruby
response = request.cart_add(
  query: {
    'CartId' => '123',
    'HMAC' => 'secret',
    'Item.1.OfferListingId' => '123',
    'Item.1.Quantity' => 1
  }
)
```

The **CartClear** operation removes all of the items in a remote shopping cart:

```ruby
response = request.cart_clear(
  query: {
    'CartId' => '123',
    'HMAC' => 'secret'
  }
)
```

The **CartGet** operation retrieves the IDs, quantities, and prices of the items, including SavedForLater ones, in a remote shopping cart:

```ruby
response = request.cart_get(
  query: {
    'CartId' => '123',
    'HMAC' => 'secret',
    'CartItemId' => '123'
  }
)
```

#### Item Lookup

The **ItemLookup** operation returns some or all of the attributes of an item, depending on the response group specified in the request. By default, the operation returns an item’s ASIN, manufacturer, product group, and title.

```ruby
response = request.item_lookup(
  query: {
    'ItemId' => '0679753354'
  }
)
```

#### Item Search

The **ItemSearch** operation returns items that satisfy the search criteria, including one or more search indices.

```ruby
response = request.item_search(
  query: {
    'Keywords' => 'Architecture',
    'SearchIndex' => 'Books'
  }
)
```

#### Similarity Lookup

The **SimilarityLookup** operation returns up to ten products per page that are similar to one or more items specified in the request. This operation is typically used to pique a customer’s interest in buying something similar to what they’ve already ordered.

```ruby
response = request.similarity_lookup(
  query: {
    'ItemId' => '0679753354'
  }
)
```

#### Configuring a request

Vacuum wraps [Excon](https://github.com/geemus/excon). Use the latter's API to tweak your request.

For example, to use a persistent connection:

```ruby
response = request.item_search(
  query: {
    'ItemId' => '0679753354'
  },
  persistent: true
)
```

### Response

The quick and dirty way to consume a response is to parse it into a Ruby hash:

```ruby
response.to_h
```

In production, you may prefer to use a custom parser to do some XML heavy-lifting:

```ruby
class MyParser
  # A parser has to respond to this.
  def self.parse(body)
    new(body)
  end

  def initialize(body)
    @body = body
  end

  # Implement parser here.
end

response.parser = MyParser
response.parse
```

If no custom parser is set, `Vacuum::Response#parse` delegates to `#to_h`.
