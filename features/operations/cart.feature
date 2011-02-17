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
      Item.1.OfferListingId : WSReoMTNALmhJ3mGNmN%2F2qM5STM7XztgIbIq98B9udGTQ4i6%2BLF9vUkV2WtpuSLH5GOBdGViiaw3ua7d7dvZ5A7XW61Bp5El1qkYbnlEjZR7NBmVenMkDRcoVc%2FUWl2kiozSiltYkEs%3D
      Item.1.Quantity       : 1
      """
    When the worker gets a response
    Then the response should be valid
    And the response should have 1 cart id
    And the response should have 1 purchase URL
    And the response should have 1 cart item
