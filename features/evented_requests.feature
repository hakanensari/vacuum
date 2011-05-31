Feature: Evented requests
  As an API consumer  
  I want to perform evented requests  
  Because that has some business value.

  Scenario: Event requests
    Given the following:
      """
      require 'em-http'

      @request = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      ResponseProxy = Struct.new(:body, :code)

      EM.run {
        http = EM::HttpRequest.new(@request.url).get

        http.callback {
          response = ResponseProxy.new(http.response, http.response_header.status)
          @response = Sucker::Response.new(response)

          EM.stop
        }
      }
      """
    Then I expect:
      """
      @response['Item'].count.should eql 1
      """
