require "rubygems"
require "bundler/setup"
require "jeweler"
require "rspec/core/rake_task"

desc "Benchmark to_hash implementations"
task "benchmark:to_hash" do
  require File.dirname(__FILE__) + "/spec/benchmark/to_hash_implementations"
end

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

RSpec::Core::RakeTask.new('spec:progress') do |spec|
  spec.spec_opts = %w(--format progress)
  spec.pattern = "spec/**/*_spec.rb"
end

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

task :default => :spec
