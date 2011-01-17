Feature: Threads
  As a worker  
  I want to query multiple locales using threads.

  Scenario: Query all locales
      Given I am playing a VCR cassette called "0816614024"
      When I tape:
      """
      params = {
        "Operation" => "ItemLookup",
        "IdType"    => "ASIN",
        "ItemId"    => "0816614024" }
      locales = Sucker.new.send :locales

      @threads = locales.map do |locale|
        Thread.new do
          worker = Sucker.new(
            :locale => locale,
            :key    => amazon["key"],
            :secret => amazon["secret"])
          worker << params
          Thread.current[:response] = worker.get
        end
      end

      @responses = @threads.map do |thread|
        thread.join
        thread[:response]
      end
      """
      Then the following should be true:
      """
      @responses.count == 6
      """
