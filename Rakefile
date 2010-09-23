require "rubygems"
require "bundler/setup"

require "fileutils"
require "jeweler"
require "rspec/core/rake_task"
require "sdoc_helpers"

desc "Clear fixtures"
task "spec:refix" do
  path = File.dirname(__FILE__) + "/spec/fixtures/*.xml"
  FileUtils.rm(Dir.glob(path))
end

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
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
  gemspec.add_dependency "nokogiri", "~> 1.4.0"
  gemspec.add_dependency "curb", "~> 0.7.0"
end

Jeweler::GemcutterTasks.new

task :default => :spec
