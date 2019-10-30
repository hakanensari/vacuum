# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
  t.ruby_opts += ['-W1']
end
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new

task default: %i[test rubocop]
