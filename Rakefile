require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Run all specs in spec directory'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
  # t.rspec_opts = "--tag ~@synchrony"
end

task :default => [:spec]
