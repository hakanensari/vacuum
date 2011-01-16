Feature: Alternative Syntax
  A worker queries using the short-hand hash syntax in Ruby 1.9.

  Scenario: Query all locales
    Given Ruby 1.9
    And a worker
    When I run:
    """
    @worker << {
      operation: "ItemLookup",
      id_type:   "ASIN",
      item_id:   "0816614024" }
    }
    """
    And the worker gets
    Then the response should have 1 item
    And the response should have 0 errors
