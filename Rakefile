require 'bundler/gem_tasks'

# add rspec task
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
task :default => ['npm:install', 'gulp:build', 'spec']

namespace :gulp do
  desc 'Run build'
  task :build do
    Dir.chdir('spec/dummy') do
      sh 'gulp build' do |ok, res|
        fail 'Error running gulp build.' unless ok
      end
    end
  end
  task :tasks do
    Dir.chdir('spec/dummy') do
      sh 'gulp --tasks' do |ok, res|
        fail 'Error running gulp --tasks.' unless ok
      end
    end
  end
end

namespace :npm do
  desc 'Run npm install'
  task :install do
    Dir.chdir('spec/dummy') do
      sh 'npm install' do |ok, res|
        fail 'Error running npm install.' unless ok
      end
    end
  end

  desc 'Clean npm node_modules'
  task :clean do
    Dir.chdir('spec/dummy') do
      sh 'rm -rf ./node_modules' do |ok, res|
        fail 'Error cleaning npm node_modules.' unless ok
      end
    end
  end

  namespace :install do
    desc 'Run a clean npm install'
    task :clean => ['npm:clean', 'npm:install']
  end
end