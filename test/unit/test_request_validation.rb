module Vacuum
  class TestRequestValidation < Minitest::Test
  	def test_search_keyword
  		api - Vacuum.new(Locales.first)
  	end
  end
end
