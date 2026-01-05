# Vacuum

Vacuum is a Ruby wrapper to the [Amazon Creators API](https://affiliate-program.amazon.com/creatorsapi/docs/en-us/). The API provides programmatic access to product information on the Amazon marketplaces.

![vacuum](https://github.com/hakanensari/vacuum/blob/main/images/vacuum.jpg?raw=true)

## Usage

### Getting Started

Create a client with your credentials.

```ruby
client = Vacuum.new(
  credential_id: "YOUR_CREDENTIAL_ID",
  credential_secret: "YOUR_CREDENTIAL_SECRET",
  version: "2.1"
)
```

The client handles authentication automatically and caches access tokens for one hour.

You can now access the API using the available operations.

```ruby
response = client.search_items(
  marketplace: "www.amazon.com",
  partner_tag: "yourtag-20",
  keywords: "lean startup"
)
response.parse
```

### Versions and Marketplaces

The `version` determines which authentication endpoint to use:

| Version | Region |
|---------|--------|
| `"2.1"` | North America |
| `"2.2"` | Europe |
| `"2.3"` | Far East |

### Operations

Each operation requires `marketplace` (e.g., `"www.amazon.com"`) and `partner_tag` parameters.

#### GetBrowseNodes

Given a BrowseNodeId, the `GetBrowseNodes` operation returns details about the specified browse node, like name, children and ancestors, depending on the resources specified in the request.

```ruby
client.get_browse_nodes(
  marketplace: "www.amazon.com",
  partner_tag: "yourtag-20",
  browse_node_ids: ["283155", "3040"],
  resources: ["browseNodes.ancestor", "browseNodes.children"]
)
```

#### GetItems

Given an Item identifier, the `GetItems` operation returns the item attributes, based on the resources specified in the request.

```ruby
client.get_items(
  marketplace: "www.amazon.com",
  partner_tag: "yourtag-20",
  item_ids: ["B0199980K4", "B000HZD168"],
  resources: ["images.primary.small", "itemInfo.title", "itemInfo.features",
              "offersV2.listings.price", "parentASIN"]
)
```

#### GetVariations

Given an ASIN, the `GetVariations` operation returns a set of items that are the same product, but differ according to a consistent theme, for example size and color.

```ruby
client.get_variations(
  marketplace: "www.amazon.com",
  partner_tag: "yourtag-20",
  asin: "B00422MCUS",
  resources: ["itemInfo.title", "variationSummary.price.highestPrice",
              "variationSummary.price.lowestPrice",
              "variationSummary.variationDimension"]
)
```

#### SearchItems

The `SearchItems` operation searches for items on Amazon based on a search query. The API returns up to ten items per search request.

```ruby
client.search_items(
  marketplace: "www.amazon.com",
  partner_tag: "yourtag-20",
  keywords: "harry potter"
)
```

### Response

Parse the response body into a hash.

```ruby
response.parse.dig("searchResult", "items")
```

### Shared Token Cache

By default, each client instance caches its own access token. In multi-process environments like Rails, you can share the token across processes by providing a cache store.

```ruby
client = Vacuum.new(
  credential_id: "YOUR_CREDENTIAL_ID",
  credential_secret: "YOUR_CREDENTIAL_SECRET",
  version: "2.1",
  cache: Rails.cache
)
```

The cache must respond to `fetch(key, expires_in:, &block)`.

## Development

Clone the repo and install dependencies.

```sh
bundle install
```

Run tests and Rubocop.

```sh
bundle exec rake
```

To run live API tests, set your credentials and run tests.

```sh
CREATORS_API_CREDENTIAL_ID=... \
CREATORS_API_CREDENTIAL_SECRET=... \
CREATORS_API_VERSION=2.1 \
CREATORS_API_PARTNER_TAG=yourtag-20 \
CREATORS_API_MARKETPLACE=www.amazon.com \
bundle exec rake test
```

---

> Amazon is a $250 billion dollar company that reacts to you buying a vacuum by going THIS GUY LOVES BUYING VACUUMS HERE ARE SOME MORE VACUUMS

— [@kibblesmith](https://web.archive.org/web/2017/https://twitter.com/kibblesmith/status/724817086309142529)
