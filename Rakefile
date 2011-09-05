require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Run all specs in spec directory'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern    = 'spec/**/*_spec.rb'
  tags = []
  tags << '~@synchrony' if RUBY_VERSION < '1.9'
  tags << '~@jruby' if RUBY_PLATFORM == 'java'
  t.rspec_opts = "--tag #{tags.join(' ')}" unless tags.empty?
end

task :default => [:spec]
