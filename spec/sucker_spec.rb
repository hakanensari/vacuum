require "spec_helper"

describe Sucker do

  subject { Sucker }

  describe ".new" do
    it "returns a Request object" do
      subject.new.should be_an_instance_of Sucker::Request
    end
  end

  describe ".configure" do
    it "yields a Config object" do
      subject.configure {|c| c.should == Sucker::Config }
    end
  end
end
