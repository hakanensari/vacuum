# http://github.com/papercavalier/sucker/issues#issue/2

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
      @worker.get.should be_valid
    end

    it "works for George Orwell, too" do
      @worker << {
        "Operation"     => "ItemSearch",
        "SearchIndex"   => "Books",
        "Author"        => "George Orwell" }
      response = @worker.get
      response.should be_valid
      response.node("TotalPages").first.should be_an_instance_of String
    end
  end
end
