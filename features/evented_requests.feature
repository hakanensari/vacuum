@synchrony
Feature: Evented requests
  As an API consumer  
  I want to perform evented requests  
  Because that has some business value.

  Scenario: Evented request
    Given the following:
      """
      require 'sucker/synchrony'

      Sucker.configure do |c|
        c.key    = amazon_key
        c.secret = amazon_secret
      end

      @request = Sucker.new
      @request << {
        operation: 'ItemLookup',
        id_type:   'ASIN',
        item_id:   '0826490786' }
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

  Scenario: Multiple evented requests executed in parallel
    Given the following:
      """
      require 'sucker/synchrony'

      @asins   = %w{ 0816614024 0143105825 0485113600 }
      @locales = Sucker::Request.locales

      @request = Sucker.new(
        key:        amazon_key,
        secret:     amazon_secret)
      @request << {
        operation: 'ItemLookup',
        id_type:   'ASIN' }
      """
    When I tape:
      """
      EM.synchrony do
        concurrency = 6

        @responses = EM::Synchrony::Iterator.new(@asins.product(@locales), concurrency).map do |(asin, locale), iter|
          @request.locale = locale
          @request << { item_id: asin }
          @request.aget { |response| iter.return(response) }
        end

        EM.stop
      end
      """
    Then I expect:
      """
      @responses.map { |response| response['Title'] }.size.should eql 18
      """
