require 'spec_helper'

module Sucker
  describe Config do

    subject { Config }

    let(:key)              { "123456" }
    let(:secret)           { "987654" }
    let(:associate_tag)    { "foo-23" }

    let(:locale)           { :en }

    describe ".key" do
      it "returns the value of @key" do
        subject.instance_variable_set(:"@key", key)
        subject.key.should == key
      end
    end

    describe ".key=" do
      it "sets @key to the passed value" do
        subject.key = key
        subject.instance_variable_get(:"@key").should == key
      end
    end

    describe ".secret" do
      it "returns the value of @secret" do
        subject.instance_variable_set(:"@secret", secret)
        subject.secret.should == secret
      end
    end

    describe ".secret=" do
      it "sets @secret to the passed value" do
        subject.secret = secret
        subject.instance_variable_get(:"@secret").should == secret
      end
    end

    describe ".associate_tag" do
      it "returns the value of @associate_tag" do
        subject.instance_variable_set(:"@associate_tag", associate_tag)
        subject.associate_tag.should == associate_tag
      end
    end

    describe ".associate_tag=" do
      it "sets @associate_tag to the passed value" do
        subject.associate_tag = associate_tag
        subject.instance_variable_get(:"@associate_tag").should == associate_tag
      end
    end

    describe ".locale" do
      it "returns the value of @locale" do
        subject.instance_variable_set(:"@locale", locale)
        subject.locale.should == locale
      end
    end

    describe ".locale=" do
      it "sets @locale to the passed value" do
        subject.locale = locale
        subject.instance_variable_get(:"@locale").should == locale
      end
    end
  end
end
