# frozen_string_literal: true

require 'forwardable'
require 'yaml'

module Locales
  class << self
    extend Forwardable
    include Enumerable

    attr_reader :all

    def_delegators :all, :each
  end

  %w[locales.yml locales.yml.example].each do |filename|
    path = File.expand_path(filename, __dir__)
    if File.exist?(path)
      @all = YAML.load_file(path)
      break
    end
  end
end
