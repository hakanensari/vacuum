Feature: Related items
  As an API consumer  
  I want to look up the related items of an item  
  Because that has some business value.

  Background:
    Given the following:
      """
      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """

  Scenario: Request related items
    Given the following:
      """
      @worker << {
        :operation         => 'ItemLookup',
        :id_type           => 'ASIN',
        :item_id           => '0679753354',
        :response_group    => 'RelatedItems',
        :relationship_type => 'AuthorityTitle' }
      """
    When I tape:
      """
      @response = @worker.get(:net_http)
      """
    Then I expect:
      """
      @response['RelatedItem'].size.should eql 1
      """

  Scenario: Authority title
    Given the following:
      """
      @worker << {
        :operation         => 'ItemLookup',
        :id_type           => 'ASIN',
        :item_id           => 'B000ASPUES',
        :response_group    => 'RelatedItems',
        :relationship_type => 'AuthorityTitle' }
      """
    When I tape:
      """
      @response = @worker.get(:net_http)
      """
    Then I expect:
      """
      @response['RelatedItem'].size.should be > 1
      """
