Feature: Parameters
  As an API consumer  
  I want to reuse my Request  
  Because that has some business value.

  Scenario: Reset parameters when setting up a new request
    Given the following:
      """
      Sucker.configure do |c|
        c.key    = amazon_key
        c.secret = amazon_secret
      end

      @request = Sucker.new
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


