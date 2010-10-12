# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sucker/version"

Gem::Specification.new do |s|
  s.name        = "sucker"
  s.version     = Sucker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hakan Ensari", "Piotr Łaszewski"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://gloss.papercavalier.com/sucker"
  s.summary     = "A Ruby wrapper to the Amazon Product Advertising API"
  s.description = "A minimal Ruby wrapper to the Amazon Product Advertising API"

  s.rubyforge_project = "sucker"

  s.add_dependency("activesupport", ">= 2.3.2")
  s.add_dependency("nokogiri", ["~> 1.4.0"])
  s.add_dependency("curb", ["~> 0.7.0"])

  s.add_development_dependency("rake", "~> 0.8.7")
  s.add_development_dependency("rdiscount", "~> 1.6.5")
  s.add_development_dependency("rspec", ["~> 2.0.0"])
  s.add_development_dependency("throttler", "~> 0.2.1")
  s.add_development_dependency("sdoc-helpers", "~> 0.1.4")
  s.add_development_dependency("vcr", "~> 1.1.2")
  s.add_development_dependency("webmock", "~> 1.4.0")

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.markdown)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end
