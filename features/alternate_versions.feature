Feature: Alternate versions
  As an API consumer  
  I want to look up alternate versions of an item  
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

  Scenario: Alternate versions response group
    Given the following:
      """
      @request << {
        :operation         => 'ItemLookup',
        :id_type           => 'ASIN',
        :item_id           => '0679753354',
        :response_group    => 'AlternateVersions' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response['AlternateVersion'].size.should be > 1
      """
