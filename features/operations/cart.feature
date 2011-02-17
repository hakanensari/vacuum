Feature: Remote cart
  As a library  
  I want to be able to manage a remote shopping cart  
  Because that has some business value to the user.

  Background:
    Given a worker

  Scenario: Create a cart
    Given the following parameters:
      """
      Operation             : CartCreate
      Item.1.OfferListingId : offer-listing-id
      Item.1.Quantity       : 1
      """
    When the worker gets a response
    Then the response should be valid
    And the response should have 1 cart id
    And the response should have 1 purchase URL
    And the response should have 1 cart item
