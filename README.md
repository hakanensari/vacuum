# Vacuum

[![Build](https://github.com/hakanensari/vacuum/workflows/build/badge.svg)](https://github.com/hakanensari/vacuum/actions)

Vacuum is a Ruby wrapper to the [Amazon Creators API](https://affiliate-program.amazon.com/creatorsapi/docs/en-us/). The API provides programmatic access to product information on the Amazon marketplaces.

![vacuum](https://github.com/hakanensari/vacuum/blob/main/images/vacuum.jpg?raw=true)

## Usage

### Authorization

Request an access token with your credentials.

```ruby
response = Vacuum::Auth.request(
  credential_id: "YOUR_CREDENTIAL_ID",
  credential_secret: "YOUR_CREDENTIAL_SECRET"
)
access_token = response.parse["access_token"]
```

Access tokens are valid for one hour. Cache and reuse them across calls.


### Getting Started

Create a request.

```ruby
request = Vacuum.new(
  marketplace: "www.amazon.com",
  access_token: access_token,
  version: "2.1", # NA: 2.1, EU: 2.2, FE: 2.3
  partner_tag: "yourtag-20"
)
```

You can now access the API using the available operations.

```ruby
response = request.search_items(keywords: "lean startup")
response.parse
```

### Operations

#### GetBrowseNodes

Given a BrowseNodeId, the `GetBrowseNodes` operation returns details about the specified browse node, like name, children and ancestors, depending on the resources specified in the request.

```ruby
request.get_browse_nodes(
  browse_node_ids: ["283155", "3040"],
  resources: ["browseNodes.ancestor", "browseNodes.children"]
)
```

#### GetItems

Given an Item identifier, the `GetItems` operation returns the item attributes, based on the resources specified in the request.

```ruby
request.get_items(
  item_ids: ["B0199980K4", "B000HZD168"],
  resources: ["images.primary.small", "itemInfo.title", "itemInfo.features",
              "offersV2.listings.price", "parentASIN"]
)
```

#### GetVariations

Given an ASIN, the `GetVariations` operation returns a set of items that are the same product, but differ according to a consistent theme, for example size and color.

```ruby
request.get_variations(
  asin: "B00422MCUS",
  resources: ["itemInfo.title", "variationSummary.price.highestPrice",
              "variationSummary.price.lowestPrice",
              "variationSummary.variationDimension"]
)
```

#### SearchItems

The `SearchItems` operation searches for items on Amazon based on a search query. The API returns up to ten items per search request.

```ruby
request.search_items(keywords: "harry potter")
```

### Response

Parse the response body into a hash.

```ruby
response.parse.dig("searchResult", "items")
```

## Development

Clone the repo and install dependencies.

```sh
bundle install
```

Run tests and Rubocop.

```sh
bundle exec rake
```

To record new VCR cassettes, set credentials and run tests.

```sh
CREATORS_API_ACCESS_TOKEN=... CREATORS_API_PARTNER_TAG=... bundle exec rake test
```
