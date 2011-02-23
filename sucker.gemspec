# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'sucker/version'

Gem::Specification.new do |s|
  s.name        = 'sucker'
  s.version     = Sucker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paper Cavalier']
  s.email       = ['code@papercavalier.com']
  s.homepage    = 'https://rubygems.org/gems/sucker'
  s.summary     = 'A Ruby wrapper to the Amazon Product Advertising API'
  s.description = 'A minimal Ruby wrapper to the Amazon Product Advertising API'

  s.rubyforge_project = 'sucker'

  s.add_dependency('activesupport', '~> 3.0.0')
  s.add_dependency('i18n', '~> 0.5.0')
  s.add_dependency('nokogiri', ['~> 1.5.0.beta.4'])

  s.add_development_dependency('cucumber', '~> 0.10.0')
  s.add_development_dependency('relish', '~> 0.2.1')
  s.add_development_dependency('rspec', ['~> 2.5.0'])
  s.add_development_dependency('throttler', '~> 0.2.1')
  s.add_development_dependency('vcr', '~> 1.6.0')
  s.add_development_dependency('webmock', '~> 1.6.2')

  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
