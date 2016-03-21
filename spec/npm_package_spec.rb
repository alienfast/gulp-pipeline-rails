require 'gulp/pipeline/rails/npm_package'

module Gulp
  module Pipeline
    module Rails
      describe NpmPackage do
        it 'should read jquery version' do
          npmPackage = NpmPackage.new
          expect(npmPackage.dependency_version('jquery')).to eq '2.2.2'
        end
      end
    end
  end
end
