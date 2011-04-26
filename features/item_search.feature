Feature: Item search
  As an API consumer  
  I want to search for items  
  Because that has some business value.

  Background:
    Given the following:
      """
      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """

  Scenario: Search for an author
    Given the following:
      """
      @worker << {
        :operation    => 'ItemSearch',
        :search_index => 'Books',
        :author       => 'George Orwell' }
      """
    When I tape:
      """
      @response = @worker.get
      """
    Then I expect:
      """
      @response['Item'].size.should eql 10
      """

  Scenario: Power search
    Given the following:
      """
      @worker << {
        :operation    => 'ItemSearch',
        :search_index => 'Books',
        :power        => 'author:lacan and not fiction',
        :sort         => 'relevancerank' }
      """
    When I tape:
      """
      @response = @worker.get
      """
    Then I expect:
      """
      @response['Item'].size.should eql 10
      """
