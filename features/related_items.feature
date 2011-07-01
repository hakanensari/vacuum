Feature: Related items
  As an API consumer  
  I want to look up the related items of an item  
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

  Scenario: Request related items
    Given the following:
      """
      @request << {
        :operation         => 'ItemLookup',
        :id_type           => 'ASIN',
        :item_id           => '0679753354',
        :response_group    => 'RelatedItems',
        :relationship_type => 'AuthorityTitle' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response['RelatedItem'].size.should eql 1
      """

  Scenario: Authority title
    Given the following:
      """
      @request << {
        :operation         => 'ItemLookup',
        :id_type           => 'ASIN',
        :item_id           => 'B000ASPUES',
        :response_group    => 'RelatedItems',
        :relationship_type => 'AuthorityTitle' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response['RelatedItem'].size.should be > 1
      """
