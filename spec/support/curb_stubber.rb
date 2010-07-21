def fixture(filename)
  File.new(File.dirname(__FILE__) + "/../fixtures/#{filename}.xml", "r").read
end

def record(filename, output)
  File.open(File.dirname(__FILE__) + "/../fixtures/#{filename}.xml", "w") { |f| f.write output }
end
