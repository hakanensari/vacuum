module Vacuum
  module Request
    # An Amazon Web Services (AWS) API request.
    class Base
      # Returns the AWS API Endpoint.
      attr :endpoint

      # Creates a new request for given locale and credentials.
      #
      # Yields the AWS API endpoint if a block is given.
      def initialize(&blk)
        @parameters = {}
        @endpoint = Endpoint.const_get(class_basename).new

        configure &blk if block_given?
      end

      # Adds given parameters to the request.
      #
      # hsh - A Hash of parameter key and value pairs.
      #
      # Returns self.
      def build(hsh)
        hsh.each do |k, v|
          k = Utils.camelize k.to_s if k.is_a? Symbol
          @parameters[k] = v.is_a?(Array) ? v.join(',') : v.to_s
        end

        self
      end

      # Resets the request to the given parameters.
      #
      # hsh - A Hash of parameter key and value pairs.
      #
      # Returns self.
      def build!(hsh = {})
        @parameters = {}
        build hsh
      end

      # Yields the AWS API Endpoint.
      #
      # Returns nothing.
      def configure(&blk)
        yield @endpoint
      end

      # Returns a Faraday::Connection.
      #
      # Yields a Faraday::Builder to configure the connection if a block is
      # given.
      def connection
        @connection ||= Faraday.new do |builder|
          builder.use Signature::Authentication, endpoint.secret

          yield builder if block_given?

          unless builder.handlers.any? { |h| h.name.include? ':Adapter:' }
            builder.adapter Faraday.default_adapter
          end
        end
      end

      # Performs the AWS API request.
      #
      # Returns a Vacuum::Response::Base or a subclass thereof.
      def get
        res = connection.get url
        Response.const_get(class_basename).new res.body, res.status
      end

      # Performs the AWS API request.
      #
      # Raises a Bad Response if the response is not valid.
      #
      # Returns a Vacuum::Response::Base or a subclass thereof.
      def get!
        unless (res = get).valid?
          raise BadResponse, "#{res.code} #{res['Code'].first}"
        end

        res
      end

      # Returns the Hash parameters of the AWS API request.
      def parameters
        default_parameters.merge @parameters
      end

      # Raises a Not Implemented Error.
      #
      # When implemented, this should return an Addressable::URI.
      def url
        raise NotImplementedError
      end

      private

      def class_basename
        self.class.name.split('::').last
      end

      def default_parameters
        { 'AWSAccessKeyId' => endpoint.key }
      end
    end
  end
end
