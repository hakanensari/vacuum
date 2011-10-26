module AmazonProduct
  # Search operations
  module SearchOperations
    # Returns up to ten items that satisfy the search criteria,
    # including one or more search indices.
    #
    # @param [String, nil] search_index search index or keyword query
    # @param [String, Hash] params keyword query or hash of parameters
    # @return [AmazonProduct::Response] a reponse
    #
    # @example The following searches the entire Amazon catalog for the
    # keyword 'book'.
    #
    #   req.search('book')
    #
    # @example The following searches the books search index for the
    # keyword 'lacan'.
    #
    #   req.search('Books', 'lacan')
    #
    # @example The following runs a power search on the books search
    # index for non-fiction titles authored by Lacan and sorts results
    # by Amazon's relevance ranking.
    #
    #   req.search('Books', :power => 'author:lacan and not fiction',
    #                           :sort  => 'relevancerank')
    #
    def search(search_index, params = nil)
      reset!
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
  end
end
