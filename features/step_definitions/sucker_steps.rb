Given /^a worker$/ do
   @worker = Sucker.new(
     :locale => :us,
     :key    => amazon['key'],
     :secret => amazon['secret'])
end

Given /^I add the following parameters:$/ do |string|
  rows = string.split("\n")

  @worker << rows.inject({}) do |hash, row|
    key, value = row.split(':')
    hash[key.strip] = value.strip.gsub(/\s/, '')
    hash
  end
end

When /^I get$/ do
  cassette_name = @worker.parameters["ItemId"].parameterize
  VCR.use_cassette(cassette_name, :record => :new_episodes) do
    @response = @worker.get
  end
end

Then /^the response should have (\d+) (.*)$/ do |count, node_name|
  @response.find(node_name.singularize.camelize).count.should eql count
end
