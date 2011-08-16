require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Run all specs in spec directory'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern    = 'spec/**/*_spec.rb'
  t.rspec_opts = '--tag ~@synchrony' if RUBY_VERSION < '1.9'
end

task :default => [:spec]
