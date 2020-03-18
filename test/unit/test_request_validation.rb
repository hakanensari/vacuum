module Vacuum
  class TestRequestValidation < Minitest::Test
  	def test_search_keyword
  		api = Vacuum.new(Locales.first)
			err = assert_raises(ArgumentError) do
				api.search_items(keywords: ['Harry Potter'])
			end

			assert_equal ":keyword argument expects a String", err.message
  	end
  end
end
