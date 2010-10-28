# http://github.com/papercavalier/sucker/issues#issue/2

require "spec_helper"

module Sucker

  describe "Item Search" do

    use_vcr_cassette "integration/item_search", :record => :new_episodes

    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"     => "ItemSearch",
        "SearchIndex"   => "Books",
        "Author"        => "Orwell" }
      worker
    end

    it "works for a single-word phrases" do
      worker.get.should be_valid
    end

    it "works for multiple-word phrases" do
      worker << {
        "Operation"     => "ItemSearch",
        "SearchIndex"   => "Books",
        "Author"        => "George Orwell" }

      response = worker.get
      response.should be_valid
      response.find("TotalPages").first.should be_an_instance_of String
    end

  end

end
