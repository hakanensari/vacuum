Feature: Item search
  As an API consumer  
  I want to search for items  
  Because that has some business value.

  Background:
    Given the following:
      """
      @request = Sucker.new(
        :key           => amazon_key,
        :secret        => amazon_secret,
        :associate_tag => amazon_associate_tag,
        :locale => :us)
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
      puts @response["ItemAttributes"].first
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
