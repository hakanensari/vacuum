require "spec_helper"

module Sucker
  describe "Kindle" do
    context "Book index" do
      use_vcr_cassette "integration/kindle", :record => :new_episodes

      let(:items) do
        worker = Sucker.new(
          :locale => "us",
          :key    => amazon["key"],
          :secret => amazon["secret"])
        worker << {
          "Operation"     => "ItemSearch",
          "SearchIndex"   => "Books",
          "Power"         => "deleuze binding:kindle",
          "ResponseGroup" => ["ItemAttributes"] }
        worker.get.find("Item")
      end

      it "finds Kindle books" do
        items.first["ItemAttributes"]["Title"].should_not be_nil
      end
    end

    context "Kindle store index" do
      use_vcr_cassette "integration/kindle_2", :record => :new_episodes

      let(:items) do
        worker = Sucker.new(
          :locale => "us",
          :key    => amazon["key"],
          :secret => amazon["secret"])
        worker << {
          "Operation"     => "ItemSearch",
          "SearchIndex"   => "KindleStore",
          "Keywords"      => "deleuze",
          "ResponseGroup" => ["ItemAttributes", "OfferSummary"] }
        worker.get.find("Item")
      end

      it "finds Kindle books" do
        items.first["ItemAttributes"]["Title"].should_not be_nil
      end
    end
  end
end
