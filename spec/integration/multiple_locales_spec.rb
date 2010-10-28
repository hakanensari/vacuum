# encoding: utf-8
require "spec_helper"

module Sucker

  describe "Item lookup" do

    context "when using threads to search multiple locales" do

      use_vcr_cassette "integration/multiple_locales", :record => :new_episodes

      it "returns matches across all locales" do
        locales = %w{us uk de ca fr jp}

        params = {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
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

        bindings = threads.map do |thread|
          thread.join
          item = thread[:response].find("Item").first
          item["ItemAttributes"]["Binding"]
        end

        bindings.uniq.should =~ %w{ Paperback Taschenbuch Broché ペーパーバック }
      end

    end

  end

end
