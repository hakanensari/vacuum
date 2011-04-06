Feature: Images
  As an API consumer  
  I want to look up product images  
  Because that has some business value.

  Background:
    Given the following:
      """
      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """

  Scenario: Look up images
    Given the following:
      """
      @worker << {
        :operation      => 'ItemLookup',
        :id_type        => 'ASIN',
        :item_id        => '0394751221',
        :response_group => 'Images' }
      """
    When I tape:
      """
      @response = @worker.get
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
