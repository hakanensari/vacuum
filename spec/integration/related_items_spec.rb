require "spec_helper"

module Sucker

  describe "Item lookup" do

    context "when response group includes related items" do

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

      context "when item is a child" do

        use_vcr_cassette "integration/related_items/child", :record => :new_episodes

        it "finds parent and related items" do
          worker << { "ItemId" => "0415246334" }
          response = worker.get
          response.find("RelatedItem").size.should eql 1
          parent_asin = response.find("RelatedItem").first["Item"]["ASIN"]
        end

      end

      context "when item is a parent" do

        use_vcr_cassette "integration/related_items/parent", :record => :new_episodes

        it "finds related items" do
          worker << { "ItemId" => "B000ASPUES" }
          response = worker.get
          response.find("RelatedItem").size.should > 1
        end

      end

    end

  end

end
