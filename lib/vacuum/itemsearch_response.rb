
module Vacuum
  class ItemSearchResponse
    attr_accessor :response
    attr_accessor :data
    def initialize(response)
      raise VacuumError.new('Not a Response') unless response.is_a?(Response)
      @response = response
      h = @response.to_h
      raise VacuumError.new('Not a ItemSearchResponse') if h['ItemSearchResponse'].nil?
      @data = h['ItemSearchResponse']
    end

    def operation_request
      @data['OperationRequest']
    end

    def is_valid?
      (@data['Items'] &&
      @data['Items']['Request'] &&
      @data['Items']['Request']['IsValid']) == 'True'
    end

    def request
      @data['Items'] &&
      @data['Items']['Request'] &&
      @data['Items']['Request']['ItemSearchRequest']
    end

    def error
      @data['Items']  &&
      @data['Items']['Request'] &&
      @data['Items']['Request']['Errors'] &&
      @data['Items']['Request']['Errors']['Error']
    end

    def items
      return nil unless is_valid?
      Items.new(@data['Items'])
    end

    class Items
      attr_accessor :items
      attr_accessor :total_results
      attr_accessor :total_pages
      attr_accessor :more_search_results_url

      def initialize(items)
        raise VacuumError.new('Not a Hash') unless items.is_a?(Hash)
        @items = items
        @total_results = @items['TotalResults'].to_i
        @total_pages = @items['TotalPages'].to_i
        @more_search_results_url = @items['MoreSearchResultsUrl']
      end

      def to_a
         @list ||= @items['Item'].to_a.inject([]) { |lst, itm| lst << Entry.new(itm) }
         @list
      end

      class Entry
        attr_accessor :item
        attr_accessor :asin
        attr_accessor :parent_asin
        attr_accessor :detail_page_url
        attr_accessor :item_links
        attr_accessor :item_attributes
        def initialize(item)
          raise VacuumError.new('Not a Hash') unless item.is_a?(Hash)
          @item = item
          @asin = @item['ASIN']
          @parent_asin = @item['ParentASIN']
          @detail_page_url = @item['DetailPageURL']
          @item_links = (@item['ItemLinks'] && @item['ItemLinks']['ItemLink']).to_a
          @item_attributes = @item['ItemAttributes']
        end
      end

    end

  end
end
