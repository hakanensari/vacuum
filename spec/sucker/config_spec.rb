require 'spec_helper'

module Sucker
  describe Config do
    describe "#configure" do
      it "yields itself" do
        subject.should_receive(:configure).and_yield(Config)
        subject.configure { |c| }
      end
    end
  end
end
