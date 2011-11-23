module Vacuum
  # An abstraction around the Amazon remote cart
  class Cart
    # @return [Vacuum::Request] the request object
    attr :request

    # @return [Vacuum::Response] the most recent response
    attr :response

    # Creates a new cart
    #
    # @param [Vacuum::Request] req an API request
    # @param [Hash] params hash of parameters
    def initialize(request, params)
      @request = request

      if params['CartId']
        perform_request 'Get', params
      else
        perform_request 'Create', params
      end
    end

    # Adds an item or items to the cart
    #
    # @param [Hash] params hash of parameters
    def add(params = {})
      perform_request 'Add', params
    end

    # Clears the cart
    #
    # @param [Hash] params hash of parameters
    def clear(params = {})
      perform_request 'Clear', params
    end

    # @return [String] the cart hmac
    def hmac
      response.find('HMAC').first
    end

    # @return [String] the cart ID
    def id
      response.find('CartId').first
    end

    # @return [Array] cart items
    def items
      response.find('CartItem')
    end

    # Modifies an existing cart
    #
    # @param [String] cart_id
    # @param [String] hmac
    # @param [Hash] params
    # @return [Vacuum::Cart] a response
    def modify(params)
      perform_request 'Modify', params
    end

    # @return [String] the purchase URL
    def url
      response.find('PurchaseURL').first
    end

    # @return [Hash] the sub total
    def total
      response.find('SubTotal').first
    end

    private

    def perform_request(operation, params)
      @request.reset!
      @request << { 'Operation' => "Cart#{operation}" }.merge(params)
      @request << { 'CartId' => id, 'HMAC' => hmac } if response

      @response = @request.get
    end
  end
end
