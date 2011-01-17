Feature: Item search
  As a worker  
  I want to search for items.

  Background:
    Given a worker

  Scenario: Search for an author
    Given I add the following parameters:
      """
      Operation   : ItemSearch
      SearchIndex : Books
      Author      : George Orwell
      """
    When the worker gets
    Then the response should be valid
    And the response should have 10 items


  Scenario: Power search
    Given I add the following parameters:
      """
      Operation   : ItemSearch
      SearchIndex : Books
      Power       : author:lacan or deleuze and not fiction
      Sort        : relevancerank
      """
    When the worker gets
    Then the response should be valid
    And the response should have 10 items

  Scenario: Search for a Kindle edition using `binding:kindle`
    Given I add the following parameters:
      """
      Operation     : ItemSearch
      SearchIndex   : Books
      Power         : deleuze binding:kindle
      ResponseGroup : ItemAttributes, Offers
      """
    When the worker gets
    Then the response should be valid
    And the response should have 10 items
    And the binding of each item should be:
      """
      Kindle Edition
      """
    And the response should have 0 offers

  Scenario: Search for a Kindle edition using the `KindleStore` search index
    Given I add the following parameters:
      """
      Operation     : ItemSearch
      SearchIndex   : KindleStore
      Keywords      : deleuze
      ResponseGroup : ItemAttributes, Offers
      """
    When the worker gets
    Then the response should be valid
    And the response should have 10 items
    And the binding of each item should be:
      """
      Kindle Edition
      """
    And the response should have 0 offers
