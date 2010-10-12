# encoding: utf-8
require "bundler"
require "rspec/core/rake_task"
require "sdoc_helpers"
require File.dirname(__FILE__) + "/lib/sucker/version"

Bundler::GemHelper.install_tasks

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
