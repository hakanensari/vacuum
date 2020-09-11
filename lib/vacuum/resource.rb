# frozen_string_literal: true

module Vacuum
  # Resources determine what information will be returned in the API response
  #
  # @see https://webservices.amazon.com/paapi5/documentation/resources.html
  class Resource
    ALL = %w[BrowseNodeInfo.BrowseNodes
             BrowseNodeInfo.BrowseNodes.Ancestor
             BrowseNodeInfo.BrowseNodes.SalesRank
             BrowseNodeInfo.WebsiteSalesRank
             CustomerReviews.Count
             CustomerReviews.StarRating
             Images.Primary.Large
             Images.Primary.Medium
             Images.Primary.Small
             Images.Variants.Large
             Images.Variants.Medium
             Images.Variants.Small
             ItemInfo.ByLineInfo
             ItemInfo.Classifications
             ItemInfo.ContentInfo
             ItemInfo.ContentRating
             ItemInfo.ExternalIds
             ItemInfo.Features
             ItemInfo.ManufactureInfo
             ItemInfo.ProductInfo
             ItemInfo.TechnicalInfo
             ItemInfo.Title
             ItemInfo.TradeInInfo
             Offers.Listings.Availability.MaxOrderQuantity
             Offers.Listings.Availability.Message
             Offers.Listings.Availability.MinOrderQuantity
             Offers.Listings.Availability.Type
             Offers.Listings.Condition
             Offers.Listings.Condition.ConditionNote
             Offers.Listings.Condition.SubCondition
             Offers.Listings.DeliveryInfo.IsAmazonFulfilled
             Offers.Listings.DeliveryInfo.IsFreeShippingEligible
             Offers.Listings.DeliveryInfo.IsPrimeEligible
             Offers.Listings.DeliveryInfo.ShippingCharges
             Offers.Listings.IsBuyBoxWinner
             Offers.Listings.LoyaltyPoints.Points
             Offers.Listings.MerchantInfo
             Offers.Listings.Price
             Offers.Listings.ProgramEligibility.IsPrimeExclusive
             Offers.Listings.ProgramEligibility.IsPrimePantry
             Offers.Listings.Promotions
             Offers.Listings.SavingBasis
             Offers.Summaries.HighestPrice
             Offers.Summaries.LowestPrice
             Offers.Summaries.OfferCount
             ParentASIN
             RentalOffers.Listings.Availability.MaxOrderQuantity
             RentalOffers.Listings.Availability.Message
             RentalOffers.Listings.Availability.MinOrderQuantity
             RentalOffers.Listings.Availability.Type
             RentalOffers.Listings.BasePrice
             RentalOffers.Listings.Condition
             RentalOffers.Listings.Condition.ConditionNote
             RentalOffers.Listings.Condition.SubCondition
             RentalOffers.Listings.DeliveryInfo.IsAmazonFulfilled
             RentalOffers.Listings.DeliveryInfo.IsFreeShippingEligible
             RentalOffers.Listings.DeliveryInfo.IsPrimeEligible
             RentalOffers.Listings.DeliveryInfo.ShippingCharges
             RentalOffers.Listings.MerchantInfo
             VariationSummary.Price.HighestPrice
             VariationSummary.Price.LowestPrice
             VariationSummary.VariationDimension].freeze
    private_constant :ALL

    # @!attribute [r] all
    # @return [Array<String>]
    def self.all
      ALL
    end

    def self.valid?(resource)
      ALL.include?(resource)
    end
  end
end
