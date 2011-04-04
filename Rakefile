require "bundler"
require 'cucumber/rake/task'
require "rspec/core/rake_task"

Bundler::GemHelper.install_tasks

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
  spec.rspec_opts = %w(-fd -c)
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => [:spec, :features]
