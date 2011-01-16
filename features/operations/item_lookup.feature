Feature: Item lookup
  A worker looks up items.

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

  Scenario: Batch request
    Given I add the following parameters:
      """
      Operation                       : ItemLookup
      ItemLookup.Shared.IdType        : ASIN
      ItemLookup.Shared.Condition     : All
      ItemLookup.Shared.MerchantId    : All
      ItemLookup.Shared.ResponseGroup : OfferFull
      ItemLookup.1.ItemId             : 0816614024
      ItemLookup.2.ItemId             : 0143105825
      """
    When I get
    Then the response should have 2 items

  Scenario: Errors
    Given I add the following parameters:
      """
      Operation : ItemLookup
      IdType    : ASIN
      ItemId    : 0816614024, 0007218095
      """
    When I get
    Then the response should have 1 item
    And the response should have 1 error
    And the message of the error should be:
      """
      0007218095 is not a valid value for ItemId. Please change this value
      and retry your request.
      """

  Scenario: Non-latin characters
    Given I set the locale to "jp"
    And I add the following parameters:
      """
      Operation : ItemLookup
      IdType    : ASIN
      ItemId    : 482224816X
      """
    When I get
    Then the response should have 1 item
    And the title of the item should be:
      """
      スティーブ・ジョブズ 驚異のプレゼン―人々を惹きつける18の法則
      """

  Scenario: Images response group
    Given I add the following parameters:
      """
      Operation     : ItemLookup
      IdType        : ASIN
      ItemId        : 0394751221
      ResponseGroup : Images
      """
    When I get
    Then the response should have 1 image set
    And the image set should contain a swatch image
    And the image set should contain a small image
    And the image set should contain a thumbnail image
    And the image set should contain a tiny image
    And the image set should contain a medium image
    And the image set should contain a large image

  Scenario: Alternate versions response group
    Given I add the following parameters:
      """
      Operation     : ItemLookup
      IdType        : ASIN
      ItemId        : 0679753354
      ResponseGroup : AlternateVersions
      """
    When I get
    Then the response should have 1 item
    And the response should have 9 alternate versions

  Scenario: Related items response group for a regular item
    Given I add the following parameters:
      """
      Operation        : ItemLookup
      IdType           : ASIN
      ItemId           : 0679753354
      ResponseGroup    : RelatedItems
      RelationshipType : AuthorityTitle
      ItemId           : 0415246334
      """
    When I get
    Then the response should have 1 related item

  Scenario: Related items response group for an authority title
    Given I add the following parameters:
      """
      Operation        : ItemLookup
      IdType           : ASIN
      ItemId           : 0679753354
      ResponseGroup    : RelatedItems
      RelationshipType : AuthorityTitle
      ItemId           : B000ASPUES
      """
    When I get
    Then the response should have more than 1 related items
