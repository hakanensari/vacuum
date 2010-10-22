require "spec_helper"

module Sucker
  describe "Seller listing search" do
    use_vcr_cassette "integration/seller_listings_search", :record => :new_episodes

    let(:listings) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"   => "SellerListingSearch",
        "SellerId"    => "A2JYSO6W6KEP83" }

      worker.get.node("SellerListings").first
    end

    it "returns page count" do
      listings["TotalPages"].to_i.should be > 0
    end

    it "returns listings" do
      listings["SellerListing"].size.should be > 0
      listings["SellerListing"].first.has_key?("Price").should be_true
    end
  end
end
