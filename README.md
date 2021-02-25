# Vacuum

[![Build](https://github.com/hakanensari/vacuum/workflows/build/badge.svg)](https://github.com/hakanensari/vacuum/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/ffbab4aa5fedf5780332/maintainability)](https://codeclimate.com/github/hakanensari/vacuum/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ffbab4aa5fedf5780332/test_coverage)](https://codeclimate.com/github/hakanensari/vacuum/test_coverage)

Vacuum is a Ruby wrapper to [Amazon Product Advertising API 5.0](https://webservices.amazon.com/paapi5/documentation/). The API provides programmatic access to query product information on the Amazon marketplaces.

Cart Form functionality is not covered by this gem but is a primary focus on [carriage gem](https://github.com/skatkov/carriage)

You need to [register first](https://webservices.amazon.com/paapi5/documentation/register-for-pa-api.html) to use the API.

![vacuum](https://github.com/hakanensari/vacuum/blob/main/images/vacuum.jpg?raw=true)

## Usage

### Getting Started

Create a request with your marketplace credentials. Set the marketplace by passing its two-letter country code.

```ruby
request = Vacuum.new(marketplace: 'US',
                     access_key: '<ACCESS_KEY>',
                     secret_key: '<SECRET_KEY>',
                     partner_tag: '<PARTNER_TAG>')
```

You can now access the API using the available operations.

```ruby
response = request.search_items(title: 'lean startup')
puts response.to_h
```

Create a persistent connection to make multiple requests.

```ruby
request.persistent
```

### Operations

Refer to the [API docs](https://webservices.amazon.com/paapi5/documentation/) for more detailed information.

#### GetBrowseNodes

Given a BrowseNodeId, the `GetBrowseNodes` operation returns details about the specified browse node, like name, children and ancestors, depending on the resources specified in the request. The names and browse node IDs of the children and ancestor browse nodes are also returned. `GetBrowseNodes` enables you to traverse the browse node hierarchy to find a browse node.

```ruby
request.get_browse_nodes(
  browse_node_ids: ['283155', '3040'],
  resources: ['BrowseNodes.Ancestor', 'BrowseNodes.Children']
)
```

#### GetItems

Given an Item identifier, the `GetItems` operation returns the item attributes, based on the resources specified in the request.

```ruby
request.get_items(
  item_ids: ['B0199980K4', 'B000HZD168', 'B01180YUXS', 'B00BKQTA4A'],
  resources: ['Images.Primary.Small', 'ItemInfo.Title', 'ItemInfo.Features',
              'Offers.Summaries.HighestPrice' , 'ParentASIN']
)
```

#### GetVariations

Given an ASIN, the `GetVariations` operation returns a set of items that are the same product, but differ according to a consistent theme, for example size and color. These items which differ according to a consistent theme are called variations. A variation is a child ASIN. The parent ASIN is an abstraction of the children items. For example, a shirt is a parent ASIN and parent ASINs cannot be sold. A child ASIN would be a blue shirt, size 16, sold by MyApparelStore. This child ASIN is one of potentially many variations. The ways in which variations differ are called dimensions.

```ruby
request.get_variations(
  asin: 'B00422MCUS',
  resources: ['ItemInfo.Title', 'VariationSummary.Price.HighestPrice',
              'VariationSummary.Price.LowestPrice',
              'VariationSummary.VariationDimension']
)
```

#### SearchItems

The `SearchItems` operation searches for items on Amazon based on a search query. The API returns up to ten items per search request.

```ruby
request.search_items(keywords: 'harry potter')
```

### Response

Consume a response by parsing it into a Ruby hash.

```ruby
response.to_h
```

You can also `#dig` into this hash.

```ruby
response.dig('ItemsResult', 'Items')
```

### Logging

Write requests and reponses to a logger using the logging feature of the [HTTP gem](https://github.com/httprb/http) under the hood:

```ruby
require 'logger'

logger = Logger.new(STDOUT)
request.use(logging: {logger: logger})
```

### Bring your parser
You can extend Vacuum with a custom parser. Just swap the original with a class or module that responds to `.parse`.

```ruby
response.parser = MyParser
response.parse
```

If no custom parser is set, `Vacuum::Response#parse` delegates to `#to_h`.

### VCR

If you are using [VCR](https://github.com/vcr/vcr) to test an app that accesses the API, you can use the custom VCR matcher of Vacuum to stub requests.

```ruby
require 'vacuum/matcher'

# in your test
VCR.insert_cassette('cassette_name',
                    match_requests_on: [Vacuum::Matcher])
```

In RSpec, use the `:paapi` metadata.

```ruby
require 'vacuum/matcher'

# in your test
it 'queries Amazon', :paapi do
end
```

## Development

Clone the repo and install dependencies.

```sh
bundle install
```

Tests and Rubocop should now pass as-is.

```sh
bundle exec rake
```

By default, the tests stub requests. Use the `RECORD` env var to record new interactions.

```sh
RECORD=true bundle exec rake test
```

You can set the `LIVE` env var to run all tests against live data.

```sh
LIVE=true bundle exec rake test
```

In either case, add actual API credentials to a [`locales.yml`](https://github.com/hakanensari/vacuum/blob/master/test/locales.yml.example) file under `test`.

## Getting Help

* Ask specific questions about the API on the [Amazon forum](https://forums.aws.amazon.com/forum.jspa?forumID=9).
* Report bugs and discuss potential features in [GitHub issues](https://github.com/hakanensari/vacuum/issues).


