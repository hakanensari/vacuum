Feature: Threads
  A worker queries multiple locales using threads.

  Scenario: Query all locales
      When I run:
      """
      params = {
        "Operation" => "ItemLookup",
        "IdType"    => "ASIN",
        "ItemId"    => "0816614024" }
      }
      locales = Sucker.new.locales

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

      """
      Then the following should be true:
      """
      responses = @threads.map do |thread|
        thread.join
        thread[:response]
      end

      responses.count == 6
      """
