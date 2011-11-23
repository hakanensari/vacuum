module Vacuum
  # Cart operations
  #
  # @see Vacuum::Cart for methods on the remote cart.
  module CartOperations
    # Creates a remote cart
    #
    # @param [Hash] params
    # @return [Vacuum::Cart] a remote cart
    #
    # @see http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/CartCreate.html
    def create_cart(params)
      Cart.new(self, params)
    end

    # Gets an existing remote cart
    #
    # @param [String] cart_id the cart ID
    # @param [String] hmac the cart HMAC
    # @param [Hash] params
    # @return [Vacuum::Cart] a remote cart
    def get_cart(cart_id, hmac, params = {})
      Cart.new(self, { 'CartId' => cart_id,
                       'HMAC'   => hmac }.merge(params))
    end
  end
end
