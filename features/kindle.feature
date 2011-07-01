Feature: Kindle search
  As an API consumer  
  I want to search for Kindle items  
  Because that has some business value.

  Background:
    Given the following:
      """
      Sucker.configure do |c|
        c.key    = amazon_key
        c.secret = amazon_secret
      end

      @request = Sucker.new
      """

  Scenario: Search for a Kindle edition using `binding:kindle`
    Given the following:
      """
      @request << {
        :operation      => 'ItemSearch',
        :search_index   => 'Books',
        :power          => 'deleuze binding:kindle',
        :response_group => 'ItemAttributes, Offers' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      items = @response['Item']
      items.size.should eql 10
      items.all? do |item|
        item['ItemAttributes']['Binding'].should eql 'Kindle Edition'
      end
      @response['Offer'].size.should eql 0
      """

  Scenario: Search for a Kindle edition using the `KindleStore` search index
    Given the following:
      """
      @request << {
        :operation      => 'ItemSearch',
        :search_index   => 'KindleStore',
        :keywords       => 'deleuze',
        :response_group => 'ItemAttributes, Offers' }
      """
    When I tape:
      """
      @response = @request.get
      """
    Then I expect:
      """
      items = @response['Item']
      items.size.should eql 10
      items.all? do |item|
        item['ItemAttributes']['Binding'].should eql 'Kindle Edition'
      end
      @response['Offer'].size.should eql 0
      """
