# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sucker/version"

Gem::Specification.new do |s|
  s.name        = "sucker"
  s.version     = Sucker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paper Cavalier"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "https://rubygems.org/gems/sucker"
  s.summary     = "A Ruby wrapper to the Amazon Product Advertising API"
  s.description = "A minimal Ruby wrapper to the Amazon Product Advertising API"

  s.rubyforge_project = "sucker"

  s.add_dependency("activesupport", ">= 2.3.2")
  s.add_dependency("i18n", "~> 0.5.0")
  s.add_dependency("nokogiri", ["~> 1.4.0"])
  s.add_dependency("curb", ["~> 0.7.0"])

  s.add_development_dependency("cucumber", "~> 0.10.0")
  s.add_development_dependency("relish", "~> 0.2.0")
  s.add_development_dependency("rspec", ["~> 2.4.0"])
  s.add_development_dependency("throttler", "~> 0.2.1")
  s.add_development_dependency("vcr", "~> 1.5.0")
  s.add_development_dependency("webmock", "~> 1.6.2")
  if RUBY_VERSION.include?("1.9")
    s.add_development_dependency "ruby-debug19", "~> 0.11.0"
  elsif RUBY_VERSION.include?("1.8")
    s.add_development_dependency "ruby-debug", "~> 0.10.0"
  end

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.md CHANGELOG.md)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end
