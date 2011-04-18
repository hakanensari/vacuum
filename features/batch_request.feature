Feature: Batch request
  As an API consumer  
  I want to look up twenty items in one request  
  Because that has some business value.

  Background:
    Given the following:
      """
      @worker = Sucker.new(
        :key    => amazon_key,
        :secret => amazon_secret,
        :locale => :us)
      """

  Scenario: Request 20 items
    Given the following:
      """
      asins = %w{
        0816614024 0143105825 0485113600 0816616779 0942299078
        0816614008 144006654X 0486400360 0486417670 087220474X
        0486454398 0268018359 1604246014 184467598X 0312427182
        1844674282 0745640974 0745646441 0826489540 1844672972 }
      
      @worker << {
        'Operation'                       => 'ItemLookup',
        'ItemLookup.Shared.IdType'        => 'ASIN',
        'ItemLookup.Shared.Condition'     => 'All',
        'ItemLookup.Shared.MerchantId'    => 'All',
        'ItemLookup.Shared.ResponseGroup' => 'OfferFull',
        'ItemLookup.1.ItemId'             => asins[0, 10],
        'ItemLookup.2.ItemId'             => asins[10, 10] }
      """
    When I tape:
      """
      @response = @worker.get(:net_http)
      """
    Then I expect:
      """
      items = @response['Item']
      items.size.should eql 20
      """
