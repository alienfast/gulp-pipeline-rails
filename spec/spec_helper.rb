ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_ROOT'] ||= File.expand_path('spec/dummy')
begin FileUtils.rm("#{ENV['RAILS_ROOT']}/log/test.log"); rescue; end # cleanup logs
require File.expand_path("#{ENV['RAILS_ROOT']}/config/environment.rb")


require 'rubygems'
require 'bundler/setup'
require 'capybara/rails'
require 'capybara/rspec'

# our gem
# require 'gulp/pipeline/rails/all'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  # config.include Gulp::Pipeline::Rails::Foo
end
