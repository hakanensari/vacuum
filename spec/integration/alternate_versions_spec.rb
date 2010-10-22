require "spec_helper"

module Sucker
  describe "Alternate versions" do
    use_vcr_cassette "integration/alternate_versions", :record => :new_episodes

    let(:worker) do
      worker = Sucker.new(
        :locale => "uk",
        :key    => amazon["key"],
        :secret => amazon["secret"])
      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "ResponseGroup" => "AlternateVersions",
        "ItemId"        => "0141044012" }
      worker
    end

    it "returns alternate versions" do
      response = worker.get
      alternate_versions = response.node("AlternateVersion")
      alternate_versions.should be_an_instance_of Array
      alternate_versions.first.should have_key "ASIN"
    end
  end
end
