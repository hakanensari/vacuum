module AmazonProduct
  module Operations
    # Cart operations
    def add_to_cart
      operation 'CartAdd'
    end

    def clear_cart
      operation 'CartClear'
    end

    def create_cart
      operation 'CartCreate'
    end

    def get_cart
      operation 'CartGet'
    end

    def modify_cart
      operation 'CartModify'
    end

    # Lookups
    def get_similarity
      operation 'SimilarityLookup'
    end

    def get_item
      operation 'ItemLookup'
    end

    def get_browse_node
      operation 'BrowseNodeLookup'
    end

    # Searches
    def search_item
      operation 'ItemSearch'
    end

    private

    def operation(value)
      @params['Operation'] = value
      get
    end
  end
end
