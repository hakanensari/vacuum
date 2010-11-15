require "spec_helper"

module Sucker

  describe "Multi" do

    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "ResponseGroup" => "ItemAttributes" }
      worker
    end

    it "quacks" do
      worker << { "ItemId" => "0816614024" }
      uris = Request::HOSTS.keys.map do |locale|
        worker.locale = locale
        worker.send(:uri).to_s
      end

      opts = { :interface => 'en0' }
      Curl::Multi.get(uris, opts) do |easy|
        response = Response.new(easy)
        pp response.find("Item").first["ASIN"]
      end
    end

  end

end

