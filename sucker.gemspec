# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/sucker/version"

Gem::Specification.new do |s|
  s.name        = "sucker"
  s.version     = Sucker::VERSION
  s.authors     = ["Hakan Ensari", "Piotr Łaszewski"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://gloss.papercavalier.com/sucker"
  s.summary     = "A Ruby wrapper to the Amazon Product Advertising API"
  s.description = "A Ruby wrapper to the Amazon Product Advertising API"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency("activesupport", ">= 2.3.2")
  s.add_dependency("nokogiri", ["~> 1.4.0"])
  s.add_dependency("curb", ["~> 0.7.0"])

  s.add_development_dependency("rdiscount")
  s.add_development_dependency("rspec", ["= 2.0.0.rc"])
  s.add_development_dependency("throttler")
  s.add_development_dependency("sdoc-helpers")

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.markdown)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
end
