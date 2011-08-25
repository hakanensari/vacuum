module AmazonProduct
  # Some shorthand notation for available operations.
  module Operations
    # Cart operations.
    def add_to_cart(params)
      cart 'Add', params
    end

    def clear_cart(params)
      cart 'Clear', params
    end

    def create_cart(params)
      cart 'Create', params
    end

    def get_cart(params)
      cart 'Get', params
    end

    def modify_cart(params)
      cart 'Modify', params
    end

    # Given up to ten item ids, returns some or all of the item attributes,
    # depending on the response group specified in the request.
    #
    # Id Type defaults to ASIN.
    #
    # Assuming you have a request object, the following returns some basic
    # information for the ASIN 0679753354:
    #
    #   request.find('0679753354')
    #
    # The following request returns cover art for the same ASIN:
    #
    #   req.find('0679753354', :response_group => 'Images')
    #
    def find(*item_ids)
      reset
      params = item_ids.last.is_a?(Hash) ? item_ids.pop : {}
      self.<<({ 'Operation' => 'ItemLookup',
                 'ItemId'    => item_ids }).merge(params)
      get
    end

    # Given a browse node ID, returns the specified browse node’s name,
    # children, and ancestors.
    def find_browse_node(browse_node_id, params = {})
      reset
      self.<<({ 'Operation'    => 'BrowseNodeLookup',
                 'BrowseNodeId' => browse_node_id }).merge(params)
      get
    end

    # Given up to ten item ids, returns up to ten products per page that are
    # similar to those items.
    def find_similar(*item_ids)
      reset
      params = item_ids.last.is_a?(Hash) ? item_ids.pop : {}
      self.<<({ 'Operation' => 'SimilarityLookup',
                 'ItemId'    => item_ids }).merge(params)
      get
    end

    # Returns up to ten items that satisfy the search criteria, including one
    # or more search indices.
    #
    # Assuming you have a request object, the following searches the entire
    # Amazon catalog for the keyword 'book':
    #
    #   request.search('book')
    #
    # The following searches the books search index for the keyword 'lacan':
    #
    #   request.search('Books', 'lacan')
    #
    # The following runs a power search on the books search index for non-
    # fiction titles authored by Lacan and sorts results by Amazon's relevance
    # ranking:
    #
    #   request.search('Books', :power => 'author:lacan and not fiction',
    #                           :sort  => 'relevancerank')
    #
    def search(search_index = nil, params = nil)
      reset

      if params.nil?
        params = { 'Keywords' => search_index }
        search_index  = 'All'
      end

      if params.is_a? String
        params = { 'Keywords' => params }
      end

      self.<<({ 'Operation'   => 'ItemSearch',
                 'SearchIndex' => search_index }.merge(params))
      get
    end

    private

    def cart(operation, params)
      reset
      self.<<({ 'Operation' => "Cart#{operation}" }.merge(params))
      get
    end
  end
end
