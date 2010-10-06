require "spec_helper"

module Sucker
  describe "Item Search" do
    before do
      @worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      @worker << {
        "Operation"     => "ItemSearch",
        "SearchIndex"   => "Books",
        "Author"        => "Orwell" }

      #Sucker.stub(@worker)
    end

    it "works for Orwell" do
      @worker.get.node("TotalPages").should_not be_nil
    end

    it "works for George Orwell, too" do
      @worker << {
        "Operation"     => "ItemSearch",
        "SearchIndex"   => "Books",
        "Author"        => "George Orwell" }
      @worker.get.node("TotalPages").should_not be_nil
    end
  end
end
