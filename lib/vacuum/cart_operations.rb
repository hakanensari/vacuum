module Vacuum
  # Cart operations
  module CartOperations
    # Creates a cart
    #
    # @param [Hash] params
    # @return [Vacuum::Cart] a cart
    def create_cart(params)
      Cart.new(self, params)
    end
  end
end
