require "spec_helper"

# http://docs.amazonwebservices.com/AWSECommerceService/2010-09-01/DG/index.html?PowerSearchSyntax.html
#
# author: ambrose and binding: (abridged or large print) and pubdate: after 11-1996
# subject: history and (Spain or Mexico) and not military and language: Spanish
# (subject: marketing and author: kotler) or (publisher: harper and subject: "high technology")
# keywords: "high tech*" and not fiction and pubdate: during 1999
# isbn: 0446394319 or 0306806819 or 1567993850

module Sucker
  describe "Power search" do
    use_vcr_cassette "integration/power_search", :record => :new_episodes

    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])
      worker << {
        "Operation"   => "ItemSearch",
        "SearchIndex" => "Books",
        "Power"       => "author:lacan or deleuze and not fiction",
        "Sort"        => "relevancerank" }
      worker
    end

    it "returns matches" do
      items  = worker.get.find("Item")
      items.size.should > 0
      items.each do |item|
        item["ItemAttributes"]["Title"].should_not be_nil
      end
    end
  end
end
