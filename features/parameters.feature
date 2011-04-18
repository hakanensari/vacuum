Feature: Parameters
  As an API consumer  
  I want to reuse my Request  
  Because that has some business value.

  Scenario: Reset parameters when setting up a new request
    Given the following:
      """
      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """
    When I run:
      """
      @worker << { 'Operation' => 'ItemLookup',
                   'IdType'    => 'ASIN' }
      """
    Then I expect:
      """
      @worker.parameters.should have_key 'Service'
      @worker.parameters.should have_key 'IdType'
      @worker.parameters['Operation'].should eql 'ItemLookup'
      """
    When I run:
      """
      @worker.reset << { 'Operation' => 'CartCreate' }
      """
    Then I expect:
      """
      @worker.parameters.should have_key 'Service'
      @worker.parameters.should_not have_key 'IdType'
      @worker.parameters['Operation'].should eql 'CartCreate'
      """


