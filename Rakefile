require "bundler/setup"

require "fileutils"
require "rspec/core/rake_task"
require "sdoc_helpers"
require File.dirname(__FILE__) + "/lib/sucker/version"

desc "Clear fixtures"
task "spec:refix" do
  path = File.dirname(__FILE__) + "/spec/fixtures/*.xml"
  FileUtils.rm(Dir.glob(path))
end

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

namespace :gem do
  desc "Build gem"
  task :build do
    system "gem build sucker.gemspec"
  end

  desc "Release gem"
  task :release => :build do
    puts "Tagging #{Sucker::VERSION}..."
    system "git tag -a v#{Sucker::VERSION} -m 'Tagging v#{Sucker::VERSION}'"
    puts "Pushing to Github..."
    system "git push --tags"
    system "gem push sucker-#{Sucker::VERSION}.gem"
  end
end

task :default => :spec
