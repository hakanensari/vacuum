Feature: Adapters
  As an API consumer  
  I want to choose my HTTP adapter  
  Because that has some business value.

  Scenario: Default to Net::HTTP
    Given the following:
      """

      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)

      @worker << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      @response = @worker.get do |client|
        @client = client
      end
      """
    Then I expect:
      """
      @client.should be_a Net::HTTP
      """

  Scenario: Require Curb before instantiating the request
    Given the following:
      """
      # Clean up
      HTTPI::Adapter.instance_variable_set(:@adapter, nil)

      require 'curb'

      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)

      @worker << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      @response = @worker.get do |client|
        @client = client
      end
      """
    Then I expect:
      """
      @client.should be_a Curl::Easy
      """

  Scenario: Require HTTClient before instantiating the request
    Given the following:
      """
      # Clean up
      HTTPI::Adapter.instance_variable_set(:@adapter, nil)

      require 'httpclient'

      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)

      @worker << {
        :operation => 'ItemLookup',
        :id_type   => 'ASIN',
        :item_id   => '0816614024' }
      """
    When I tape:
      """
      @response = @worker.get do |client|
        @client = client
      end
      """
    Then I expect:
      """
      @client.should be_a HTTPClient
      """
