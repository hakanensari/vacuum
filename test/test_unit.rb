# frozen_string_literal: true

require_relative 'test_helper'

class VacuumResponseTest < Minitest::Test
  def test_parsable_response
    assert_equal(['ItemsResult'], res.parse.keys)
  end

  def test_force_encodes_body
    assert_equal 'UTF-8', res.body.encoding.name
  end

  def test_casts_to_hash
    assert_kind_of Hash, res.to_h
  end

  def test_digs
    assert_equal(['Items'], res.dig('ItemsResult').keys)
  end

  def test_bad_locale
    assert_raises(Vacuum::BadLocale) do
      client.get_items(item_ids: ['B07212L4G2'],
                       resources: RESOURCES,
                       marketplace: :zz)
    end
  end

  private

  MockResponse = Struct.new(:body)

  BODY = %(
    {\"ItemsResult\":{\"Items\":[{\"ASIN\":\"B07212L4G2\",\"DetailPageURL\":\"https://www.amazon.com/dp/B07212L4G2?tag=test-20&linkCode=ogi&th=1&psc=1\",\"Images\":{\"Primary\":{\"Large\":{\"Height\":432,\"URL\":\"https://m.media-amazon.com/images/I/41OmiwuvQeL.jpg\",\"Width\":500}}},\"ItemInfo\":{\"ByLineInfo\":{\"Brand\":{\"DisplayValue\":\"adidas Originals\",\"Label\":\"Brand\",\"Locale\":\"en_US\"},\"Manufacturer\":{\"DisplayValue\":\"adidas Originals\",\"Label\":\"Manufacturer\",\"Locale\":\"en_US\"}},\"Classifications\":{\"Binding\":{\"DisplayValue\":\"T-shirt\",\"Label\":\"Binding\",\"Locale\":\"en_US\"},\"ProductGroup\":{\"DisplayValue\":\"Apparel\",\"Label\":\"ProductGroup\",\"Locale\":\"en_US\"}},\"ExternalIds\":{\"EANs\":{\"DisplayValues\":[\"0191027129406\"],\"Label\":\"EAN\",\"Locale\":\"en_US\"},\"UPCs\":{\"DisplayValues\":[\"191027129406\"],\"Label\":\"UPC\",\"Locale\":\"en_US\"}},\"Features\":{\"DisplayValues\":[\"adidas Clothing Size Guide\",\"It's like a baseball tee, but cooler!\",\"Regular fit is eased, but not sloppy, and perfect for any activity.\",\"Crew neckline.\",\"Short raglan sleeves. \\nIconic three-stripes down sleeves and a Trefoil logo at left chest. \\nStraight hemline. \\n100% cotton.\\nMachine wash, tumble dry.\\nImported.\\nMeasurements:\\n\\n     Length: 29 in\\n    \\n\\nProduct measurements were taken using size MD. Please note that measurements may vary by size.\"],\"Label\":\"Features\",\"Locale\":\"en_US\"},\"ManufactureInfo\":{\"ItemPartNumber\":{\"DisplayValue\":\"CW1207-700\",\"Label\":\"PartNumber\",\"Locale\":\"en_US\"},\"Model\":{\"DisplayValue\":\"CW1207\",\"Label\":\"Model\",\"Locale\":\"en_US\"}},\"ProductInfo\":{\"Color\":{\"DisplayValue\":\"Intense Lemons\",\"Label\":\"Color\",\"Locale\":\"en_US\"},\"IsAdultProduct\":{\"DisplayValue\":false,\"Label\":\"IsAdultProduct\",\"Locale\":\"en_US\"},\"Size\":{\"DisplayValue\":\"Medium\",\"Label\":\"Size\",\"Locale\":\"en_US\"}},\"Title\":{\"DisplayValue\":\"adidas Originals 3-Stripes Tee Intense Lemons MD\",\"Label\":\"Title\",\"Locale\":\"en_US\"}},\"Offers\":{\"Listings\":[{\"Id\":\"nTbwLoohuOnOlcqzv3tU2slwGKE%2FICZt7LOpgMtt0P6vP6Ny%2FR1RtwQ6ps130j5qKlGvZpPS0Rmtuk6y3KWCyc2v9%2B2IR0Capgos7s%2F7ahQZBCwtlpijdxRwz0c4wr8vlac3t1swYcflYBEevCPiMlajMNM2Qwra\",\"Price\":{\"Amount\":29.09,\"Currency\":\"USD\",\"DisplayAmount\":\"$29.09\"},\"ViolatesMAP\":false}]},\"ParentASIN\":\"B071K31B2L\"}]}}
  )

  def res
    Vacuum::Response.new MockResponse.new(BODY)
  end
end
