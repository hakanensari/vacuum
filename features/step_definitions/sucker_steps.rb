Given /^the following:$/ do |string|
  eval string
end

When /^I run:$/ do |string|
  eval string
end

When /^I tape:$/ do |string|
  VCR.use_cassette(cassette_name, :record => :new_episodes) do
    eval string
  end
end

Then /^I expect:$/ do |string|
  eval string
end

Then /^debug$/ do
  debugger
  print nil
end

Then /^show me the response$/ do
  begin
    pp @response.to_hash
  rescue
    pp @responses.first.to_hash
  end
end
