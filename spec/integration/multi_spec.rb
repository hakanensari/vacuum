require "spec_helper"

module Sucker

  describe "Multi" do
    # WebMock doesn't work with Curl::Multi yet

    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])
      asins = %w{
          0816614024 0143105825 0485113600 0816616779 0942299078
          0816614008 144006654X 0486400360 0486417670 087220474X}
      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "ResponseGroup" => "ItemAttributes",
        "ItemId"        => asins }
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

