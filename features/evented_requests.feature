Feature: Evented requests
  As an API consumer  
  I want to perform evented requests  
  Because that has some business value.

  @synchrony
  Scenario: Event requests
    Given the following:
      """
      require 'sucker/synchrony'

      @request = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0826490786' }
      """
    When I tape:
      """

      EM.synchrony do
        @response = @request.get
        EM.stop
      end
      """
    Then I expect:
      """
      @response['Item'].count.should eql 1
      """
