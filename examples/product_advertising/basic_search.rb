require File.expand_path('../shared.rb', __FILE__)

items = @req.search(:books, 'Deleuze').find('Item')

binding.pry
