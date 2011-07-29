# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'sucker/version'

Gem::Specification.new do |s|
  s.name        = 'sucker'
  s.version     = Sucker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paper Cavalier']
  s.email       = ['code@papercavalier.com']
  s.homepage    = 'http://code.papercavalier.com/sucker/'
  s.summary     = %q{A Ruby wrapper to the Amazon Product Advertising API}
  s.description = %q{Sucker is a minimal Ruby wrapper to the Amazon Product Advertising API.}

  s.rubyforge_project = 'sucker'

  {
    'httpclient'          => '~> 2.2',
    'nokogiri'            => '~> 1.4'
  }.each do |lib, version|
    s.add_runtime_dependency lib, version
  end

  {
    'cucumber'            => '~> 1.0',
    'em-http-request'     => '~> 1.0.0.beta.4',
    'em-synchrony'        => '~> 0.3.0.beta.1',
    'rake'                => '~> 0.9',
    'rspec'               => '~> 2.6',
    'vcr'                 => '~> 1.10',
    'webmock'             => '~> 1.6'
  }.each do |lib, version|
    s.add_development_dependency lib, version
  end

  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
