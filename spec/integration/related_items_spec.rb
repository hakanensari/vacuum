require "spec_helper"

module Sucker
  describe "Related items" do
    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"         => "ItemLookup",
        "IdType"            => "ASIN",
        "ResponseGroup"     => ["RelatedItems"],
        "RelationshipType"  => "AuthorityTitle" }

      worker
    end

    context "Child" do
      use_vcr_cassette "integration/related_items/child", :record => :new_episodes

      it "finds parent and related items" do
        worker << { "ItemId" => "0415246334" }
        response = worker.get
        response.node("RelatedItem").size.should eql 1
        parent_asin = response.node("RelatedItem").first["Item"]["ASIN"]
      end
    end

    context "Parent" do
      use_vcr_cassette "integration/related_items/parent", :record => :new_episodes

      it "finds related items" do
        worker << { "ItemId" => "B000ASPUES" }
        response = worker.get
        response.node("RelatedItem").size.should > 1
      end
    end
  end
end
