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

  s.add_dependency('httpclient', '~> 2.2.0.2')
  s.add_dependency('nokogiri', '~> 1.4.0')

  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
