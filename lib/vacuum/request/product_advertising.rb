module Vacuum
  module Request
    # A Product Advertising API request.
    class ProductAdvertising < Base
      # Looks up attributes of up to twenty items.
      #
      # item_ids - Splat Array of item IDs. The last element may optionally
      #            specify a Hash of parameter key and value pairs.
      #
      # Examples
      #
      #   request.find '0679753354', response_group: 'Images'
      #
      # Raises a Bad Response if response is not valid.
      #
      # Returns a Vacuum::Response::ProductAdvertising.
      def look_up(*item_ids)
        given = item_ids.last.is_a?(Hash) ? item_ids.pop : {}

        params = begin
          case item_ids.size
          when 1..10
            {
              'Operation' => 'ItemLookup',
              'ItemId'    => item_ids
            }.merge given
          when 11..20
            default = {
              'Operation'           => 'ItemLookup',
              'ItemLookup.1.ItemId' => item_ids.shift(10),
              'ItemLookup.2.ItemId' => item_ids
            }

            if version = given.delete('Version') || given.delete(:version)
              default['Version'] = version
            end

            given.reduce(default) do |a, (k, v)|
              a.merge "ItemLookup.Shared.#{Utils.camelize k.to_s}" => v
            end
          else
            raise ArgumentError, "Can't look up #{item_ids.size} items"
          end
        end
        rebuild params

        check_response
      end

      # Searches for items that satisfy the given criteria, including one or
      # more search indices.
      #
      # index           - Symbol search index
      # query_or_params - String keyword query or Hash of parameter key and
      #                   value pairs.
      #
      # Examples
      #
      #   # Search the entire Amazon catalog for Deleuze.
      #   request.search :all, 'Deleuze'
      #
      #   # Search books for non-fiction titles authored by Deleuze and sort
      #   # results by relevance.
      #   request.search :books, power: 'author:lacan and not fiction',
      #                          sort:  'relevancerank'
      #
      # Raises a Bad Response if response is not valid.
      #
      # Returns a Vacuum::Response::ProductAdvertising.
      def search(index, query_or_params = nil)
        params = case query_or_params
                 when String
                   { 'Keywords' => query_or_params }
                 else
                   query_or_params
                 end
        rebuild params.merge! 'Operation'   => 'ItemSearch',
                             'SearchIndex' => Utils.camelize(index.to_s)

        check_response
      end

      # Returns the Addressable::URI URL of the Product Advertising API
      # request.
      def url
        Addressable::URI.new :scheme        => 'http',
                             :host          => endpoint.host,
                             :path          => '/onca/xml',
                             :query_values  => parameters
      end

      private

      def default_parameters
        super.merge 'AssociateTag' => endpoint.tag,
                    'Service'      => 'AWSECommerceService',
                    'Version'      => '2011-08-01'
      end
    end
  end
end
