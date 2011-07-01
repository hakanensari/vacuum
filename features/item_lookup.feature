Feature: Item lookup
  As an API consumer  
  I want to look up items  
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

  Scenario: Single item
    Given the following:
      """
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response['Item'].size.should eql 1
      """

  Scenario: Error
    Given the following:
      """
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0007218095' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response.errors.size.should eql 1
      error = @response.errors.first
      error['Message'].should include 'not a valid value'
      """

  Scenario: Non-latin text
    Given the following:
      """
      Sucker.configure(:jp) do |c|
        c.key    = amazon_key
        c.secret = amazon_secret
      end

      @request = Sucker.new(:jp)
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '482224816X' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      item = @response['Item'].first
      item['ItemAttributes']['Title'].should include "ス"
      """
