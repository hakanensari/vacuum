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
    fields = row.split(':')
    key = fields.shift
    value = fields.join(':')
    hash[key.strip] = value.strip.gsub(/,\s+/, ',')
    hash
  end
end

When /^the worker gets(| all)$/ do |locales|
  params = @worker.parameters
  unique_query =
    params["Author"] ||
    params["Power"] ||
    params["Keywords"] ||
    params["Author"] ||
    params["SellerId"] ||
    params["ItemId"] ||
    params["ItemLookup.1.ItemId"] + "," + params["ItemLookup.2.ItemId"]
  cassette_name = unique_query.parameterize
  VCR.use_cassette(cassette_name, :record => :new_episodes) do
    case locales.strip
    when ''
      @response = @worker.get
    when 'all'
      @responses = @worker.get :all
    end
  end
end

Then /^there should be (\d+) responses$/ do |count|
  @responses.count.should eql count
end

Then /^the response should be valid$/ do
  @response.should be_valid
end

Then /^the responses should be valid$/ do
  @responses.each { |resp| resp.should be_valid }
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

Then /^the (.+) of each (.+) should be:$/ do |attribute, object, string|
  node_name = object.tr(' ', '_').camelize
  key = attribute.camelize
  @they =@response.find(node_name)
  @they.each do |it|
    recursive_find_by_key(it, key).should eql string.tr("\n", ' ')
  end
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
