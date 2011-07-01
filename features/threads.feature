Feature: Threads
  As an API consumer  
  I want to thread requests  
  Because that has some business value.

  Scenario: Thread requests to all six Amazon locales
    Given the following:
      """
      Sucker::Config::LOCALES.map do |locale|
        Sucker.configure(locale) do |c|
          c.key    = amazon_key
          c.secret = amazon_secret
        end
      end
      @request = Sucker.new
      @request << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      threads = Sucker::Config::LOCALES.map do |locale|
        Thread.new do
          request = Sucker.new(locale)
          request << @request.parameters.normalize

          Thread.current[:response] = request.get
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
