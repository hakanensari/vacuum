require "spec_helper"

module Sucker
  describe "Related items" do
    before do
      @worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      @worker << {
        "Operation"         => "ItemLookup",
        "IdType"            => "ASIN",
        "ResponseGroup"     => ["RelatedItems"],
        "RelationshipType"  => "AuthorityTitle" }

      Sucker.stub(@worker)
    end

    it "finds authority title and related items" do
      @worker << { "ItemId" => "0415246334" }
      response = @worker.get
      response.node("RelatedItem").size.should eql 1
      parent_asin = response.node("RelatedItem").first["Item"]["ASIN"]

      @worker << { "ItemId" => parent_asin }
      response = @worker.get
      response.node("RelatedItem").size.should > 1
    end

    it "foos items with no related items" do
      @worker << { "ItemId" => "0804819491" }
      response = @worker.get
      response.node("RelatedItem").size.should eql 0
    end
  end
end
