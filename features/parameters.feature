Feature: Parameters
  As an API consumer  
  I want to reuse my Request  
  Because that has some business value.

  Scenario: Reset parameters when setting up a new request
    Given the following:
      """
      @request = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """
    When I run:
      """
      @request << { 'Operation' => 'ItemLookup',
                   'IdType'    => 'ASIN' }
      """
    Then I expect:
      """
      @request.parameters['Service'].should_not be_nil
      @request.parameters['IdType'].should_not be_nil
      @request.parameters['Operation'].should eql 'ItemLookup'
      """
    When I run:
      """
      @request.reset << { 'Operation' => 'CartCreate' }
      """
    Then I expect:
      """
      @request.parameters['Service'].should_not be_nil
      @request.parameters['IdType'].should be_nil
      @request.parameters['Operation'].should eql 'CartCreate'
      """


