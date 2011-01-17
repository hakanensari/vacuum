Feature: Curl::Multi
  As a worker  
  I want to query multiple locales using Curl::Multi.

  Background:
    Given a worker

  Scenario: Query all locales
    Given I add the following parameters:
      """
      Operation : ItemLookup
      IdType    : ASIN
      ItemId    : 0816614024
      """
    When the worker gets all
    Then there should be 6 responses
    And the responses should be valid
