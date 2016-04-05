require 'bundler/gem_tasks'

# add rspec task
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
task :default => ['node:version', 'npm:install', 'gulp:all', 'spec']

namespace :gulp do
  desc 'Run all'
  task :all do
    Dir.chdir('spec/dummy') do
      sh 'gulp all' do |ok, res|
        fail 'Error running gulp all.' unless ok
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

namespace :node do
  desc 'Run node -v'
  task :version do
    Dir.chdir('spec/dummy') do
      sh 'node -v' do |ok, res|
        fail 'Error running node -v.' unless ok
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