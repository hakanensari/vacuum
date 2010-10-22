require "spec_helper"

module Sucker
  describe "Keyword Search" do
    use_vcr_cassette "integration/keyword_search", :record => :all

    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])
      worker << {
        "Operation"   => "ItemSearch",
        "SearchIndex" => "Books",
        "Keywords"    => "zizek lacan",
        "Sort"        => "relevancerank" } # also try salesrank and reviewrank
      worker
    end

    it "returns matches" do
      response = worker.get
      response.node("Item").each do |item|
        item["ItemAttributes"]["Title"].should_not be_nil

        puts "*****************************"
        pp item["ItemAttributes"]
        puts item["ItemAttributes"]["Author"]
        puts item["ItemAttributes"]["Title"]
        puts "*****************************"
      end
    end
  end
end
