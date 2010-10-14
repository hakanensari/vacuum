# encoding: utf-8
def asins_fixture
  File.new(File.expand_path("../../fixtures/asins.txt", __FILE__), "r").map { |line| line.chomp }
end
