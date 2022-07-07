# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'vacuum/version'

Gem::Specification.new do |gem|
  gem.name        = 'vacuum'
  gem.version     = Vacuum::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Hakan Ensari', 'Stanislav Katkov']
  gem.email       = ['me@hakanensari.com', 'sk@skylup.com']
  gem.homepage    = 'https://github.com/hakanensari/vacuum'
  gem.description = 'A wrapper to the Amazon Product Advertising API'
  gem.summary     = 'Amazon Product Advertising in Ruby'
  gem.license     = 'MIT'

  gem.files         = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  gem.require_paths = ['lib']

  gem.add_dependency 'aws-sigv4', '~> 1.0'
  gem.add_dependency 'http', '>= 4.0', '< 6.0'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubocop-minitest'
  gem.add_development_dependency 'rubocop-rake'
  gem.add_development_dependency 'simplecov', '0.17.1'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
  gem.required_ruby_version = '>= 2.7'
  gem.metadata['rubygems_mfa_required'] = 'true'
end
