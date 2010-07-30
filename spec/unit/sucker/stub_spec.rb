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
    end
  end
end
