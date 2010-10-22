require "spec_helper"

module Sucker
  describe "Keyword Search" do
    use_vcr_cassette "integration/keyword_search", :record => :new_episodes

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
      items  = worker.get.node("Item")
      items.size.should > 0
      items.each do |item|
        item["ItemAttributes"]["Title"].should_not be_nil
      end
    end
  end
end
