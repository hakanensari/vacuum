require "spec_helper"

module Sucker
  describe "Seller Listing Search" do
    before do
      @sucker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      # @sucker.curl { |curl| curl.verbose = true }

      @sucker << {
        "Operation"   => "SellerListingSearch",
        "SellerId"    => "A31N271NVIORU3" }
      @sucker.fetch
      @listings = @sucker.to_h["SellerListingSearchResponse"]["SellerListings"]
    end

    it "returns page count" do
      @listings["TotalPages"].to_i.should be > 0
    end

    it "returns listings" do
      @listings["SellerListing"].size.should be > 0
      @listings["SellerListing"].first.has_key?("Price").should be_true
    end
  end
end
