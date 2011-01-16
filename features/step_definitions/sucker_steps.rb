Given /^a worker$/ do
   @worker = Sucker.new(
     :locale => :us,
     :key    => amazon['key'],
     :secret => amazon['secret'])
end

Given /^I set the (\w+) to "([^"]*)"$/ do |attribute, locale|
  @worker.send "#{attribute}=", locale
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
  params = @worker.parameters
  item_ids =
    params["ItemId"] ||
    params["ItemLookup.1.ItemId"] + "," + params["ItemLookup.2.ItemId"]
  cassette_name = item_ids.parameterize
  VCR.use_cassette(cassette_name, :record => :new_episodes) do
    @response = @worker.get
  end
end

Then /^the response should have (\d+) (.+)$/ do |count, object|
  is_singular = count == 1
  node_name = object.tr(' ', '_').singularize.camelize
  @they = @response.find(node_name)
  if is_singular
    instance_variable_set("@#{node_name}", @they.last)
  end

  @they.count.should eql count
end

Then /^the response should have more than (\d+) (.+)$/ do |count, object|
  node_name = object.tr(' ', '_').singularize.camelize
  @they = @response.find(node_name)
  @they.count.should > count
end

Then /^the (.+) of the (.+) should be:$/ do |attribute, object, string|
  node_name = object.tr(' ', '_').singularize.camelize
  key = attribute.camelize
  @it = instance_variable_get("@#{node_name}")

  recursive_find_by_key(@it, key).should eql string.tr("\n", ' ')
end

Then /^the (.+) should contain an? (.+)$/ do |parent, child|
  node_name = parent.tr(' ', '_').singularize.camelize
  key = child.tr(' ', '_').singularize.camelize
  @it = instance_variable_get("@#{node_name}")

  @it.should have_key(key)
end

Then /^show me the response$/ do
  pp @response.to_hash
end
