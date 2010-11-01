def asins_fixture
  asins = File.new(File.expand_path("../../fixtures/asins.txt", __FILE__), "r").map { |line| line.chomp }
  if block_given?
    asins.each { |asin| yield asin }
  end

  asins
end
