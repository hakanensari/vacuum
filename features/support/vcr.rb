require 'vcr'

VCR.config do |c|
  c.cassette_library_dir     = File.dirname(__FILE__) + '/../../spec/fixtures/cassette_library'
  c.default_cassette_options = {
    :record             => :none,
    :match_requests_on  => [:host] }
  c.stub_with :webmock
end
