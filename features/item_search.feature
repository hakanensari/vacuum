Feature: Item search
  As an API consumer  
  I want to search for items  
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

  Scenario: Search for an author
    Given the following:
      """
      @request << {
        :operation    => 'ItemSearch',
        :search_index => 'Books',
        :author       => 'George Orwell' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response['Item'].size.should eql 10
      """

  Scenario: Power search
    Given the following:
      """
      @request << {
        :operation    => 'ItemSearch',
        :search_index => 'Books',
        :power        => 'author:lacan and not fiction',
        :sort         => 'relevancerank' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      @response['Item'].size.should eql 10
      """
