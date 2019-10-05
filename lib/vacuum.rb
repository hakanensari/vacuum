# frozen_string_literal: true

require 'forwardable'
require 'vacuum/request'
require 'vacuum/version'

# Vacuum is a Ruby wrapper to the Amazon Product Advertising API.
module Vacuum
  class << self
    extend Forwardable

    def_delegator Vacuum::Request, :new
  end

  Market = Struct.new(:host, :region) do
    def site
      host.sub('webservices', 'www')
    end

    def endpoint(operation)
      "https://#{host}/paapi5/#{operation.downcase}"
    end
  end

  MARKETPLACES = {
    au: Market.new('webservices.amazon.com.au', 'us-west-2'),
    br: Market.new('webservices.amazon.com.br', 'us-east-1'),
    ca: Market.new('webservices.amazon.ca',     'us-east-1'),
    fr: Market.new('webservices.amazon.fr',     'eu-west-1'),
    de: Market.new('webservices.amazon.de',     'eu-west-1'),
    in: Market.new('webservices.amazon.in',     'eu-west-1'),
    it: Market.new('webservices.amazon.it',     'eu-west-1'),
    jp: Market.new('webservices.amazon.co.jp',  'us-west-2'),
    mx: Market.new('webservices.amazon.com.mx', 'us-east-1'),
    es: Market.new('webservices.amazon.es',     'eu-west-1'),
    tr: Market.new('webservices.amazon.com.tr', 'eu-west-1'),
    ae: Market.new('webservices.amazon.ae',     'eu-west-1'),
    uk: Market.new('webservices.amazon.co.uk',  'eu-west-1'),
    us: Market.new('webservices.amazon.com',    'us-east-1')
  }.freeze

  OPERATIONS = %w[
    GetBrowseNodes
    GetItems
    GetVariations
    SearchItems
  ].freeze

  RESOURCES = [
    'BrowseNodeInfo.BrowseNodes',
    'BrowseNodeInfo.BrowseNodes.Ancestor',
    'BrowseNodeInfo.BrowseNodes.SalesRank',
    'BrowseNodeInfo.WebsiteSalesRank',
    'CustomerReviews.Count',
    'CustomerReviews.StarRating',
    'Images.Primary.Small',
    'Images.Primary.Medium',
    'Images.Primary.Large',
    'Images.Variants.Small',
    'Images.Variants.Medium',
    'Images.Variants.Large',
    'ItemInfo.ByLineInfo',
    'ItemInfo.ContentInfo',
    'ItemInfo.ContentRating',
    'ItemInfo.Classifications',
    'ItemInfo.ExternalIds',
    'ItemInfo.Features',
    'ItemInfo.ManufactureInfo',
    'ItemInfo.ProductInfo',
    'ItemInfo.TechnicalInfo',
    'ItemInfo.Title',
    'ItemInfo.TradeInInfo',
    'Offers.Listings.Availability.MaxOrderQuantity',
    'Offers.Listings.Availability.Message',
    'Offers.Listings.Availability.MinOrderQuantity',
    'Offers.Listings.Availability.Type',
    'Offers.Listings.Condition',
    'Offers.Listings.Condition.SubCondition',
    'Offers.Listings.DeliveryInfo.IsAmazonFulfilled',
    'Offers.Listings.DeliveryInfo.IsFreeShippingEligible',
    'Offers.Listings.DeliveryInfo.IsPrimeEligible',
    'Offers.Listings.DeliveryInfo.ShippingCharges',
    'Offers.Listings.IsBuyBoxWinner',
    'Offers.Listings.LoyaltyPoints.Points',
    'Offers.Listings.MerchantInfo',
    'Offers.Listings.Price',
    'Offers.Listings.ProgramEligibility.IsPrimeExclusive',
    'Offers.Listings.ProgramEligibility.IsPrimePantry',
    'Offers.Listings.Promotions',
    'Offers.Listings.SavingBasis',
    'Offers.Summaries.HighestPrice',
    'Offers.Summaries.LowestPrice',
    'Offers.Summaries.OfferCount',
    'ParentASIN',
    'RentalOffers.Listings.Availability.MaxOrderQuantity',
    'RentalOffers.Listings.Availability.Message',
    'RentalOffers.Listings.Availability.MinOrderQuantity',
    'RentalOffers.Listings.Availability.Type',
    'RentalOffers.Listings.BasePrice',
    'RentalOffers.Listings.Condition',
    'RentalOffers.Listings.Condition.SubCondition',
    'RentalOffers.Listings.DeliveryInfo.IsAmazonFulfilled',
    'RentalOffers.Listings.DeliveryInfo.IsFreeShippingEligible',
    'RentalOffers.Listings.DeliveryInfo.IsPrimeEligible',
    'RentalOffers.Listings.DeliveryInfo.ShippingCharges',
    'RentalOffers.Listings.MerchantInfo'
  ].freeze
end
