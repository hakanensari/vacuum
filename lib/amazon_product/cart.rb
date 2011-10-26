module AmazonProduct
  class Cart
    # @return [String] cart_id
    attr :id

    # @return [String] hmac
    attr :hmac

    attr :items

    # @return [AmazonProduct::Response] last_response last response
    # returned by the Amazon API
    attr :last_response

    # @return [String] purchase_url
    attr :purchase_url

    attr :sub_total

    # Creates a new cart
    #
    # @param [AmazonProduct::Request] req an API request
    # @param [Hash] params a hash of parameters
    def initialize(req, params)
      @req = req
      get 'Create', params
    end

    # Clears the cart
    #
    # @param [Hash] params a hash of parameters
    def clear(params = {})
      get 'Clear', params
    end

    private

    def get(operation, params)
      @req.reset!

      if id
        @req << { 'CartId'    => id,
                  'HMAC'      => hmac }
      end

      @req << { 'Operation' => "Cart#{operation}" }.merge(params)

      @last_response = @req.get
      @items         = @last_response.find('CartItems')
      @id            = @last_response.find('CartId').first
      @hmac          = @last_response.find('HMAC').first
      @purchase_url  = @last_response.find('PurchaseURL').first
      @sub_total     = @last_response.find('SubTotal').first
    end

    # Add items to cart
    #
    # @param [String] cart_id
    # @param [String] hmac
    # @param [Hash] params
    # @return [AmazonProduct::Cart] a response
    # def add_to_cart(cart_id, hmac, params)
    #   cartify 'Add', { 'CartId' => cart_id,
    #                    'HMAC'   => hmac }.merge(params)
    # end


    # Gets an existing cart
    #
    # @param [String] cart_id
    # @param [String] hmac
    # @param [Hash] params
    # @return [AmazonProduct::Cart] a response
    # def get_cart(cart_id, hmac, params)
    #   cartify 'Get', { 'CartId' => cart_id,
    #                    'HMAC'   => hmac }.merge(params)
    # end

    # Modifies an existing cart
    #
    # @param [String] cart_id
    # @param [String] hmac
    # @param [Hash] params
    # @return [AmazonProduct::Cart] a response
    # def modify_cart(cart_id, hmac, params)
    #   cartify 'Modify', { 'CartId' => cart_id,
    #                       'HMAC'   => hmac }.merge(params)
    # end
  end
end
