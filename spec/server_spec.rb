require 'rails_helper'

require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      describe Server, type: :request do

        # TODO: it appears our rack component isn't even serving....

        it 'should have middleware registered' do
          x = ::Rails.configuration.middleware
          puts x
        end


        context 'debug' do
          let(:debug) { true }
          it 'valid' do
            assert_ok('favicon.ico', :image, debug)
            assert_ok('application.css', :stylesheet, debug)
            assert_ok('application.js', :javascript, debug)

            x = ::Rails.configuration.middleware
            puts x.map(&:name)

          end

          it 'not_found' do
            assert_not_found('foo.png', :image, debug)
          end

          it 'js sourcemap should be found' do
            assert_ok('application.js.map', :javascript, debug)
          end
        end

        context 'digest' do
          let(:debug) { false }

          it 'valid' do
            assert_ok('favicon.ico', :image, debug)
            assert_ok('application.css', :stylesheet, debug)
            assert_ok('application.js', :javascript, debug)
          end

          it 'not_found' do
            assert_not_found('foo.png', :image, debug)
          end
          it 'js sourcemap should not be found' do
            assert_not_found('application.js.map', :javascript, debug)
          end

          it 'manifest should be forbidden' do
            assert_not_found('rev-manifest.json', nil, debug)
          end
        end

        private

        def assert_not_found(asset, type, debug)
          # expect{get_request(asset, type, debug)}.to raise_error ActionController::RoutingError
          get_request(asset, type, debug)
          expect(response).to be_not_found
        end

        def assert_forbidden(asset, type, debug)
          get_request(asset, type, debug)
          expect(response).to be_forbidden
        end

        def assert_ok(asset, type, debug)
          get_request(asset, type, debug)
          expect(response).to be_success

          # use the header to ensure we are actually serving the files

          # FIXME: enable this
          # expect(response.headers[Gulp::Pipeline::Rails::VERSION_HEADER]).to eq(Gulp::Pipeline::Rails::VERSION)
        end

        def get_request(asset, type, debug)

          # reset the cached values in assets
          Assets.reset

          # FIXME: assets are getting mounted/setup once, not per debug etc

          # FIXME: something is intercepting/serving, not our mounted component

          if debug
            ::Rails.application.config.assets.debug = true
          end

          options = if type then
                      {type: type}
                    else
                      {}
                    end

          # https://www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
          path = Assets.compute_asset_path(asset, options)

          puts "get: #{path}"
          get path
        end
      end
    end
  end
end
