Feature: Item lookup
  In order fetch item attributes from Amazon
  As a developer using Sucker
  I want to execute an item lookup.

  Background:
    Given I set up a worker

  Scenario: Single item lookup
    Given I add the following parameters:
      | Operation | ItemLookup |
      | IdType    | ASIN       |
      | ItemId    | 0816614024 |
    When I "get"
    Then the response should have 1 "item"

  Scenario: Multiple item lookup
    Given I add the following parameters:
      | Operation | ItemLookup             |
      | IdType    | ASIN                   |
      | ItemId    | 0816614024, 0143105825 |
    When I "get"
    Then the response should have 2 "items"

  Scenario: Batch request
    Given I add the following parameters:
      | Operation | ItemLookup |

