# frozen_string_literal: true

require "yaml"

module Credentials
  extend Enumerable

  class << self
    attr_reader :all

    def each(&) = @all.each(&)
  end

  path = File.expand_path("credentials.yml", __dir__)
  path = "#{path}.example" unless File.exist?(path)

  @all = YAML.load_file(path).to_h do |entry|
    [entry["version"], (entry if entry["credential_id"])]
  end
end
