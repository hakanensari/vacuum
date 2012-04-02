require File.expand_path('../shared.rb', __FILE__)

res   = @req.look_up '0816614024'
items = res.find 'Item'

binding.pry
