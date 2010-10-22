# encoding: utf-8
require "spec_helper"

module Sucker
  describe "Multiple locales" do
    use_vcr_cassette "integration/multiple_locales", :record => :new_episodes

    it "threads multiple requests" do
      locales = %w{us uk de ca fr jp}

      params = {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "Condition"     => "All",
        "MerchantId"    => "All",
        "ResponseGroup" => "ItemAttributes",
        "ItemId"        => "0816614024" }

      threads = locales.map do |locale|
        Thread.new do
          worker = Sucker.new(
            :locale => locale,
            :key    => amazon["key"],
            :secret => amazon["secret"])
          worker << params
          Thread.current[:response] = worker.get
        end
      end

      bindings = []
      threads.each do |thread|
        thread.join
        item = thread[:response].node("Item").first
        bindings << item["ItemAttributes"]["Binding"]
      end

      bindings.uniq.should =~ %w{ Paperback Taschenbuch Broché ペーパーバック }
    end
  end
end
