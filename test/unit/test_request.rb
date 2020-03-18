module Vacuum
  class TestRequest < Minitest::Test
  	def test_search_keywords
			err = assert_raises(ArgumentError) do
				api.search_items(keywords: ['Harry Potter'])
			end

			assert_equal ':keyword argument expects a String', err.message
		end

		def test_search_resources
			err = assert_raises(ArgumentError) do
				api.search_items(
						keywords: 'Harry Potter',
						resources: %w(Images.Primary.Large ItemInfo.ExternalIds Offer.Listings.Price))
			end

			assert_equal 'There is not such resource: Offer.Listings.Price', err.message
		end

		def api
			@api ||= Vacuum.new(Locales.first)
		end
  end
end
