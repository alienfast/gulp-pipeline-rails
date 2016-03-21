# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gulp/pipeline/rails/version'

Gem::Specification.new do |s|
  s.name          = 'gulp-pipeline-rails'
  s.version       = Gulp::Pipeline::Rails::VERSION
  s.authors       = ['Kevin Ross']
  s.email         = ['kevin.ross@alienfast.com']
  s.summary       = %q{Rails asset pipeline replacement using gulp-pipeline assets}
  s.description   = %q{Remove sprockets and use gulp-pipeline.  Simpler, faster, and integrates very well with the rest of the assets community.}
  s.homepage      = ''
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'mysql2', '>= 0.3.13', '< 0.5'

  s.add_dependency 'rails', '>= 4.2.1', '< 5.0'
  s.add_dependency 'scss_lint'
end
