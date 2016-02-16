# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gulp/pipeline/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'gulp-pipeline-rails'
  spec.version       = Gulp::Pipeline::Rails::VERSION
  spec.authors       = ['Kevin Ross']
  spec.email         = ['kevin.ross@alienfast.com']
  spec.summary       = %q{Rails asset pipeline replacement using gulp-pipeline assets}
  spec.description   = %q{Remove sprockets and use gulp-pipeline.  Simpler, faster, and integrates very well with the rest of the assets community.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
