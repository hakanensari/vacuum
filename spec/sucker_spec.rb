require "spec_helper"

describe Sucker do
  describe ".new" do
    it "returns a request" do
      subject.new.should be_a Sucker::Request
    end
  end

  describe ".configure" do
    it "yields a configuration object" do
      subject.should_receive(:configure).and_yield(Sucker::Config)
      subject.configure { |c| }
    end
  end
end
