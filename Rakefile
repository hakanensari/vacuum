require "rubygems"
require "bundler/setup"

require "jeweler"
require "rspec/core/rake_task"

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

if RUBY_VERSION.include?("1.8")
  require "jeweler"

  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "sucker"
    gemspec.summary = "A paper-thin Ruby wrapper to the Amazon Product Advertising API"
    gemspec.description = "A paper-thin Ruby wrapper to the Amazon Product Advertising API"
    gemspec.files = Dir.glob("lib/**/*") + %w{LICENSE README.rdoc}
    gemspec.require_path = "lib"
    gemspec.email = "code@papercavalier.com"
    gemspec.homepage = "http://github.com/papercavalier/sucker"
    gemspec.authors = ["Hakan Ensari", "Piotr Laszewski"]
    gemspec.add_dependency "activesupport", ">= 3.0.0.rc"
    gemspec.add_dependency "nokogiri", ">= 1.4.3.1"
    gemspec.add_dependency "curb", ">= 0.7.7.1"
  end

  Jeweler::GemcutterTasks.new
end

