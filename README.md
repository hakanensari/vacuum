# Vacuum

[![CircleCI](https://circleci.com/gh/hakanensari/vacuum/tree/master.svg?style=svg)](https://circleci.com/gh/hakanensari/vacuum/tree/master)

Vacuum is a light-weight Ruby wrapper to [Amazon Product Advertising API 5.0](https://webservices.amazon.com/paapi5/documentation/). The API provides programmatic access to search and get detailed product information on the Amazon marketplaces.

![vacuum](http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png)

## Usage

Vacuum follows the nomenclature of the Product Advertising API. The examples below are based on examples in the [Amazon docs](https://webservices.amazon.com/paapi5/documentation/).

### Getting Started

You need to [register as an affiliate](https://affiliate-program.amazon.com) and [apply for API access](https://affiliate-program.amazon.com/assoc_credentials/home) on each marketplace you want to query product information.

Create a request with your marketplace credentials, passing the two-letter country code of the marketplace.

```ruby
request = Vacuum.new(marketplace: 'US',
                     access_key: '<ACCESS_KEY>',
                     secret_key: '<SECRET_KEY>',
                     partner_tag: '<PARTNER_TAG>')
```

Vacuum uses [HTTPI](https://github.com/savonrb/httpi) under the hood. You can swap the HTTP library it uses if you prefer an alternative one for speed or introspection.

```ruby
HTTPI.adapter = :http
```

### Operations

#### GetBrowseNodes

Given a BrowseNodeId, the `GetBrowseNodes` operation returns details about the specified browse node like name, children and ancestors depending on the resources specified in the request. The names and browse node IDs of the children and ancestor browse nodes are also returned. `GetBrowseNodes` enables you to traverse the browse node hierarchy to find a browse node.

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

The `SearchItems` operation searches for items on Amazon based on a search query. The Amazon Product Advertising API returns up to ten items per search request.

```ruby
request.search_items(keywords: 'harry potter')
```

### Response

The quick and dirty way to consume a response is to parse into a Ruby hash:

```ruby
response.to_h
```

You can also `#dig` into the returned Hash:

```ruby
response.dig('ItemsResult', 'Items')
```

### VCR Support

If you are using [VCR](https://github.com/vcr/vcr) to test an app that accesses the Product Advertising API, you can use the custom VCR matcher of Vacuum to stub requests.

```ruby
require 'vacuum/matcher'

VCR.insert_cassette('paapi', match_requests_on: [Vacuum::Matcher])
```

## Testing

Tests should pass as-is once you install dependencies.

```sh
bundle exec rake
```

By default, all requests are stubbed. Use the `RECORD` env var to record new or modified interactions.

```sh
bundle exec RECORD=true rake
```

You can also run tests against live data.

```shell
bundle exec LIVE=true rake
```

In either case, you will want to add actual API credentials to a [`locales.yml`](https://github.com/hakanensari/vacuum/blob/master/test/locales.yml.example) file in the `test` directory.

## Getting Help

* Ask specific questions about the API on the [Amazon forum](https://forums.aws.amazon.com/forum.jspa?forumID=9).
* Report bugs and discuss potential features in [GitHub issues](https://github.com/hakanensari/vacuum/issues).


