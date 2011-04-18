Feature: Seller listing search
  As an API consumer  
  I want to search seller listings  
  Because that has some business value.

  Background:
    Given the following:
      """
      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """

  Scenario: Browse a seller's listings
    Given the following:
      """
      @worker << {
        :operation         => 'SellerListingSearch',
        :seller_id         => 'A2XAZ8JI5FY49I' }
      """
    When I tape:
      """
      @response = @worker.get
      """
    Then I expect:
      """
      @response['SellerListing'].size.should eql 10
      """

  Scenario: Large inventories do not return any results
    Given the following:
      """
      @worker << {
        :operation         => 'SellerListingSearch',
        :seller_id         => 'A2H6NH4SQYFZ4M' }
      """
    When I tape:
      """
      @response = @worker.get(:net_http)
      """
    Then I expect:
      """
			@response['SellerListing'].size.should eql 0
			@response.errors.size.should eql 1
			error = @response.errors.first
			error['Message'].should include 'We did not find any matches'
      """
