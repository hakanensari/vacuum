require "spec_helper"

describe Sucker do
  describe ".new" do
    it "returns a request" do
      subject.new.should be_a Sucker::Request
    end
  end
end
