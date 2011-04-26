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
  s.summary     = %q{A Ruby wrapper to the Amazon Product Advertising API}
  s.description = %q{A Ruby wrapper to the Amazon Product Advertising API}

  s.rubyforge_project = 'sucker'

  {
    'httpclient'          => '~> 2.2.0.2',
    'nokogiri'            => '~> 1.4.0'
  }.each do |lib, version|
    s.add_runtime_dependency lib, version
  end

  {
    'bundler'             => '~> 1.0.0',
    'addressable'         => '2.2.4',
    'cucumber'            => '~> 0.10.0',
    'rake'                => '~> 0.8.7',
    'relish'              => '~> 0.3.0.pre',
    'rspec'               => '~> 2.5.0',
    'vcr'                 => '~> 1.9.0',
    'webmock'             => '~> 1.6.0'
  }.each do |lib, version|
    s.add_development_dependency lib, version
  end

  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
