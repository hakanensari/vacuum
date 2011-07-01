require 'spec_helper'

module Sucker
  describe Config do
    let(:locale) { :us }

    describe "LOCALES" do
      it "returns available locales" do
        Config::LOCALES.should =~ [:us, :uk, :de, :ca, :fr, :jp]
      end
    end

    describe ".new" do
      subject { Config.new(locale) }

      it "sets the locale" do
        subject.locale.should eql locale
      end
    end

    describe "#host" do
      subject { Config.new(locale).host }

      it "returns the host for specified locale" do
        subject.should eql Config::HOSTS[locale]
      end
    end
  end
end
