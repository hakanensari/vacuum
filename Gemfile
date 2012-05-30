source 'http://rubygems.org'
gemspec

gem 'jruby-openssl', :platform => :jruby

group :development do
  gem 'em-synchrony'
  gem 'em-http-request'
  gem 'structure'
  gem 'simplecov', :platform => :mri_19, :require => :false
end

gem 'pry' unless ENV['CI']
