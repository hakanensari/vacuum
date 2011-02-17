Feature: Item search
  As a library  
  I want to be able to search for items  
  Because that has some business value to the user.

  Background:
    Given a worker

  Scenario: Search for an author
    Given the following parameters:
      """
      Operation   : ItemSearch
      SearchIndex : Books
      Author      : George Orwell
      """
    When the worker gets a response
    Then the response should be valid
    And the response should have 10 items


  Scenario: Power search
    Given the following parameters:
      """
      Operation   : ItemSearch
      SearchIndex : Books
      Power       : author:lacan or deleuze and not fiction
      Sort        : relevancerank
      """
    When the worker gets a response
    Then the response should be valid
    And the response should have 10 items

  Scenario: Search for a Kindle edition using `binding:kindle`
    Given the following parameters:
      """
      Operation     : ItemSearch
      SearchIndex   : Books
      Power         : deleuze binding:kindle
      ResponseGroup : ItemAttributes, Offers
      """
    When the worker gets a response
    Then the response should be valid
    And the response should have 10 items
    And the binding of each item should be:
      """
      Kindle Edition
      """
    And the response should have 0 offers

  Scenario: Search for a Kindle edition using the `KindleStore` search index
    Given the following parameters:
      """
      Operation     : ItemSearch
      SearchIndex   : KindleStore
      Keywords      : deleuze
      ResponseGroup : ItemAttributes, Offers
      """
    When the worker gets a response
    Then the response should be valid
    And the response should have 10 items
    And the binding of each item should be:
      """
      Kindle Edition
      """
    And the response should have 0 offers
