require "spec_helper"

describe Sucker do
  let(:locale) { :uk }

  describe ".new" do
    it "returns a request" do
      subject.new.should be_a Sucker::Request
    end

    context "when passed a locale" do
      it "returns a request for that locale" do
        request = subject.new(locale)
        request.config.locale.should eql locale
      end
    end

    context "when not passed a locale" do
      it "returns a request for the US" do
        request = subject.new
        request.config.locale.should eql :us
      end
    end

    context "when passed a hash of configuration options" do
      let(:request) { subject.new(:locale => locale) }

      it "returns a request for specified locale" do
        request.config.locale.should eql locale
      end

      it "outputs a deprecation warning" do
        Kernel.should_receive(:warn)
        request
      end
    end
  end

  describe ".configure" do
    context "when passed a locale" do
      it "yields the configuration for that locale" do
        config = nil
        subject.configure(locale) {|c| config = c }
        config.locale.should eql locale
      end
    end

    context "when not passed a locale" do
      it "yields the configuration for the US" do
        config = nil
        subject.configure {|c| config = c }
        config.locale.should eql :us
      end
    end
  end
end
