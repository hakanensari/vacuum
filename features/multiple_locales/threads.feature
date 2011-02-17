Feature: Threads
  As a user  
  I want to thread queries to multiple Amazon locales  
  Because that data has some business value to me.

  Scenario: Query all six Amazon locales
      Given I am playing a VCR cassette called "0816614024"
      When I tape:
      """
      params = {
        "Operation" => "ItemLookup",
        "IdType"    => "ASIN",
        "ItemId"    => "0816614024" }

      worker = Sucker.new(
        :key    => amazon["key"],
        :secret => amazon["secret"])

      locales = Sucker::Request::HOSTS.keys

      threads = locales.map do |locale|
        Thread.new do
          worker.locale = locale
          worker << params
          Thread.current[:response] = worker.get
        end
      end

      @responses = threads.map do |thread|
        thread.join
        thread[:response]
      end
      """
      Then the following should be true:
      """
      @responses.count == 6
      """
