module Sucker
  class MockResponse < Response
    def initialize(mock_response_body)
      self.body = mock_response_body
      self.code = 200
      self.time = 0.1
    end
  end

  class << self
    attr_accessor :fixtures_path

    # Records a request on first run and fakes subsequently
    def stub(request)
      request.instance_eval do
        self.class.send :define_method, :fixture do
          filename = parameters.
            values.
            flatten.
            join.
            gsub(/(?:[aeiou13579]|[^\w])+/i, '')[0, 251]

          "#{Sucker.fixtures_path}/#{filename}.xml"
        end

        self.class.send :define_method, :get do
          if File.exists?(fixture)
            MockResponse.new(File.new(fixture, "r").read)
          else
            curl.url = uri.to_s
            curl.perform
            response = Response.new(curl)

            File.open(fixture, "w") { |f| f.write response.body }

            response
          end
        end
      end
    end
  end
end
