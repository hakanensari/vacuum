Feature: Item lookup
  As a worker I want to look up items.

  Background:
    Given a worker

  Scenario: Look up a single item
    Given I add the following parameters:
      """
      Operation : ItemLookup
      IdType    : ASIN
      ItemId    : 0816614024
      """
    When I get
    Then the response should have 1 item

  Scenario: Look up two items
    Given I add the following parameters:
      """
      Operation : ItemLookup
      IdType    : ASIN
      ItemId    : 0816614024, 0143105825
      """
    When I get
    Then the response should have 2 items

  @wip
  Scenario: Batch request
    Given I add the following parameters:
      """
      Operation : ItemLookup
      """
