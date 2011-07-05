require "spec_helper"

describe Sucker do
  describe ".new" do
    it "returns a request" do
      subject.new.should be_a Sucker::Request
    end
  end

  describe ".configure" do
    it "yields the configuration" do
      Sucker::Config.should_receive(:configure)
      subject.configure { |c| }
    end
  end
end
