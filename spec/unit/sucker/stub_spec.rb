require "spec_helper"
require "fileutils"

module Sucker
  describe "Stub" do
    before do
      @worker = Sucker.new(
        :locale => "us",
        :secret => "secret")
    end

    context ".stub" do
      before do
        Sucker.stub(@worker)
      end

      after do
        FileUtils.rm @worker.fixture, :force => true
      end

      it "defines Request#fixture" do
        @worker.should respond_to :fixture
        @worker.fixture.should include Sucker.fixtures_path
      end

      it "performs the request if fixture is not available" do
        curl = @worker.curl
        curl.stub(:get).and_return(nil)
        curl.stub!(:body_str).and_return("foo")

        @worker.get

        File.exists?(@worker.fixture).should be_true
        File.new(@worker.fixture, "r").read.should eql "foo"
      end

      it "mocks the request if fixture is available" do
        File.open(@worker.fixture, "w") { |f| f.write "bar" }

        @worker.get.body.should eql "bar"
      end

      context "defines:" do
        context "#fixture" do
          it "ignores odd numbers" do
            @worker << { "Foo" => "13579" }
            @worker.fixture.should_not match /[^\/]*[13579][^\/]*xml$/
          end

          it "does not ignore odd numbers" do
            @worker << { "Foo" => "24680" }
            (0..8).step(2) do |odd_no|
              @worker.fixture.should match Regexp.new(odd_no.to_s)
            end
          end

          it "ignores vowels" do
            @worker << { "Foo" => "aeiou" }
            @worker.fixture.should_not match /[^\/]*[aeiou][^\/]*xml$/
          end

          it "does not ignore consonants" do
            @worker << { "Foo" =>  ("a".."z").to_a.join }
            @worker.fixture.should include(("a".."z").to_a.join.gsub(/[aeiou]/, ""))
          end

          it "ignores non-alphanumeric characters" do
            @worker << { "Foo" => ";+*&!~" }
            @worker.fixture.should_not match /[;+*&!~]/
          end
        end
      end
    end
  end
end
