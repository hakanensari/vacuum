# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.test_files = FileList["spec/**/*_spec.rb"]
  t.ruby_opts += ["-W1"]
end
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new

task default: [:spec, :rubocop]
