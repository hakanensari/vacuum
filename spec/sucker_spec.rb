require "spec_helper"

describe Sucker do

  describe ".new" do

    it "returns a Request object" do
      Sucker.new.should be_an_instance_of Sucker::Request
    end

  end

end
