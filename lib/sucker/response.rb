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
      XmlSimple.xml_in(body, { "ForceArray" => false })
    end
  end
end
