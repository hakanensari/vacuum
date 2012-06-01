# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'vacuum/version'

Gem::Specification.new do |s|
  s.name        = 'vacuum'
  s.version     = Vacuum::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Hakan Ensari']
  s.email       = ['hakan.ensari@papercavalier.com']
  s.homepage    = 'https://github.com/hakanensari/vacuum'
  s.summary     = 'A wrapper to various Amazon Web Services APIs'
  s.description = <<-EOF
Vacuum is a wrapper to various Amazon Web Services (AWS) APIs, including
Product Advertising and Marketplace Web Services (MWS).
  EOF

  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'rspec', '~> 2.9'
  s.add_runtime_dependency 'addressable', '>= 2.2.7', '< 3.0'
  s.add_runtime_dependency 'faraday', '~> 0.8.1'
  s.add_runtime_dependency 'nokogiri', '~> 1.5'

  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
