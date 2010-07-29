module Sucker

  # A wrapper around the cURL response
  class Response
    attr_accessor :body, :code, :time

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    def to_h
      Crack::XML.parse(body)
    end
  end
end
