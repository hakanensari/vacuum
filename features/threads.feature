Feature: Threads
  As an API consumer  
  I want to thread requests  
  Because that has some business value.

  Scenario: Thread requests to all six Amazon locales
    Given the following:
      """
      @request = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret)
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      threads = Sucker::Request.locales.map do |locale|
        Thread.new do
          @request.locale = locale
          Thread.current[:response] = @request.get
        end
      end

      @responses = threads.map do |thread|
        thread.join
        thread[:response]
      end
      """
    Then I expect:
      """
      @responses.count.should eql 6
      """
