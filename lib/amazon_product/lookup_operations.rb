module AmazonProduct
  # Lookup operations
  module LookupOperations
    # Given up to ten item ids, returns some or all of the item
    # attributes, depending on the response group specified in the
    # request.
    #
    # @param [Array] item_ids splat of item IDs and an optional hash of
    # parameters
    # @return [AmazonProduct::Response] a response
    #
    # Id Type defaults to ASIN.
    #
    # @example The following returns some basic information for the
    # ASIN 0679753354.
    #
    #   req.find('0679753354')
    #
    # @example The following request returns cover art for the same
    # ASIN.
    #
    #   req.find('0679753354', :response_group => 'Images')
    #
    def find(*item_ids)
      reset!
      params = item_ids.last.is_a?(Hash) ? item_ids.pop : {}
      self.<<({ 'Operation' => 'ItemLookup',
                'ItemId'    => item_ids }.merge(params))

      get
    end

    # Given a browse node ID, returns the specified browse node’s name,
    # children, and ancestors.
    #
    # @param [String] browse_node_id browse node ID
    # @params [Hash] params hash of parameters
    # @return [AmazonProduct::Response] a response
    def find_browse_node(browse_node_id, params = {})
      reset!
      self.<<({ 'Operation'    => 'BrowseNodeLookup',
                'BrowseNodeId' => browse_node_id }.merge(params))

      get
    end

    # Given up to ten item ids, returns up to ten products per page
    # that are similar to those items
    #
    # @param [Array] item_ids splat of item IDs and an optional hash of
    # parameters
    # @return [AmazonProduct::Response] a response
    def find_similar(*item_ids)
      reset!
      params = item_ids.last.is_a?(Hash) ? item_ids.pop : {}
      self.<<({ 'Operation' => 'SimilarityLookup',
                'ItemId'    => item_ids }.merge(params))

      get
    end
  end
end
