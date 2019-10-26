# frozen_string_literal: true

require 'forwardable'
require 'vacuum/request'
require 'vacuum/version'

# Vacuum is a Ruby wrapper to the Amazon Product Advertising API.
module Vacuum
  class << self
    extend Forwardable

    def_delegator Vacuum::Request, :new
  end

  # OPTIONAL_PARAMS = {
  #   condition: 'Condition',
  #   currency_of_preference: 'CurrencyOfPreference',
  #   languages_of_preference: 'LanguagesOfPreference',
  #   offer_count: 'OfferCount',
  #   # ONLY FOR GET_VARIATIONS
  #   variation_count: 'VariationCount',
  #   variation_page: 'VariationPage',
  #   # SEARCH
  #   keywords: 'Keywords'
  # }.freeze
end
