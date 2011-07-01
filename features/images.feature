Feature: Images
  As an API consumer  
  I want to look up product images  
  Because that has some business value.

  Background:
    Given the following:
      """
      Sucker.configure do |c|
        c.key    = amazon_key
        c.secret = amazon_secret
      end
      @request = Sucker.new
      """

  Scenario: Look up images
    Given the following:
      """
      @request << {
        :operation      => 'ItemLookup',
        :id_type        => 'ASIN',
        :item_id        => '0394751221',
        :response_group => 'Images' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      image_set = @response['ImageSet'].first
      image_set.should have_key 'SwatchImage'
      image_set.should have_key 'SmallImage'
      image_set.should have_key 'ThumbnailImage'
      image_set.should have_key 'TinyImage'
      image_set.should have_key 'MediumImage'
      image_set.should have_key 'LargeImage'
      """
