require "spec_helper"

module Sucker
  describe "Client" do
    before(:each) do
      @client = Sucker::Client.new
    end

    it "exists" do
      @client.should be_an_instance_of Sucker::Client
    end
  end
end
