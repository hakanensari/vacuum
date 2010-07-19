require "spec_helper"

describe "Sucker" do
  it "has an API version" do
    Sucker::API_VERSION.should be_an_instance_of String
  end
end
