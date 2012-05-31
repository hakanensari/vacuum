shared_examples 'a request' do
  describe '#connection' do
    let(:middleware) do
      request.connection.builder.handlers
    end

    it 'returns a Faraday Connection' do
      request.connection.should be_a Faraday::Connection
    end

    it 'adds Signature Authentication to middleware stack' do
      middleware.should include Vacuum::Request::Signature::Authentication
    end

    it 'yields a builder' do
      klass = Class.new Faraday::Middleware
      request.connection do |builder|
        builder.use klass
      end
      middleware.should include klass
    end
  end

  describe '#endpoint' do
    it 'returns an AWS API endpoint' do
      request.endpoint.should be_a Vacuum::Endpoint::Base
    end
  end

  describe '#build' do
    it 'merges passed key and value pairs into the parameters' do
      request.build 'Key' => 'value'
      request.parameters['Key'].should eql 'value'
    end

    it 'casts Symbol keys to camel-cased String' do
      request.build :foo_bar => 'value'
      request.parameters.should have_key 'FooBar'
    end

    it 'does not modify String keys' do
      request.build 'foo_bar' => 'value'
      request.parameters.should have_key 'foo_bar'
    end

    it 'casts values to String' do
      request.build 'Key' => 1
      request.parameters['Key'].should eql '1'
    end

    it 'concatenates Array values with a comma' do
      request.build 'Key' => ['foo', 'bar']
      request.parameters['Key'].should eql 'foo,bar'
    end

    it 'returns self' do
      request.build({}).should eql request
    end
  end

  describe '#reset_build' do
    it 'clears existing parameters' do
      request.build 'Key' => 'value'
      request.reset_build.parameters.should_not have_key 'Key'
    end
  end

  describe '#configure' do
    it 'configures the AWS API endpoint' do
      request.configure do |config|
        config.locale = 'JP'
      end
      request.endpoint.locale.should eql 'JP'
    end
  end

  describe '#get' do
    context 'given an implemented url' do
      before do
        request.stub!(:url).and_return Addressable::URI.parse 'http://example.com'
      end

      it 'returns a Response' do
        request.get.should be_a Vacuum::Response::Base
      end
    end
  end

  describe '#check_response' do
    let(:response_class) do
      Vacuum::Response.const_get request.send(:class_basename)
    end

    context 'when response is bad' do
      let(:mock_response) do
        body = <<-XML.gsub!(/>\s+</, '><').strip!
          <?xml version=\"1.0\" ?>
          <ErrorResponse>
            <Error>
              <Code>RequestThrottled</Code>
              <Message>Request from 192.168.0.1 is throttled.</Message>
            </Error>
            <RequestID>123</RequestID>
          </ErrorResponse>
        XML

        response_class.new body, 503
      end

      before do
        request.stub!(:get).and_return mock_response
      end

      it 'raises a Bad Response error' do
        expect do
          request.check_response
        end.to raise_error Vacuum::BadResponse, '503 RequestThrottled'
      end
    end

    context 'when response is OK' do
      let(:mock_response) do
        response_class.new('', 200)
      end

      before do
        request.stub!(:get).and_return mock_response
      end

      it 'returns the response' do
        request.check_response.should eql mock_response
      end
    end
  end

  describe '#parameters' do
    it 'includes default parameters' do
      request.parameters.should have_key 'AWSAccessKeyId'
    end

  end
end
