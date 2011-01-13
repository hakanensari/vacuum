require "bundler"
require "rspec/core/rake_task"

Bundler::GemHelper.install_tasks

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
