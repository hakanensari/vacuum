def fixture(filename)
  File.new(File.dirname(__FILE__) + "/../fixtures/#{filename}.xml", "r").read
end
