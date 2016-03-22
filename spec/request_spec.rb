require 'rails_helper'

require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      describe Railtie, type: :request do

        context 'debug' do
          let(:debug) { true }
          it 'valid' do
            assert_ok('favicon.ico', debug)
            assert_ok('application.css', debug)
            assert_ok('application.js', debug)
          end

          it 'not_found' do
            assert_not_found('foo.png', debug)
          end

          it 'js sourcemap should be found' do
            assert_ok('application.js.map', debug)
          end
        end

        context 'digest' do
          let(:debug) { false }

          it 'valid' do
            assert_ok('favicon.ico', debug)
            assert_ok('application.css', debug)
            assert_ok('application.js', debug)
          end

          it 'not found' do
            expect{assert_not_found('foo.png', debug)}.to raise_error /not found in the manifest/
          end

          it 'js sourcemap should not be found in manifest' do
            expect{assert_not_found('application.js.map', debug)}.to raise_error /not found in the manifest/
          end
        end

        private

        def assert_not_found(asset, debug)
          # expect{get_request(asset, type, debug)}.to raise_error ActionController::RoutingError
          expect { get_request(asset, debug) }.to raise_error ::ActionController::RoutingError, /No route matches/
        end

        def assert_forbidden(asset, debug)
          get_request(asset, debug)
          expect(response).to be_forbidden
        end

        def assert_ok(asset, debug)
          get_request(asset, debug)
          expect(response).to be_success
        end

        def get_request(asset, debug)

          # reset the cached values in assets
          Assets.reset

          if debug
            ::Rails.application.config.assets.debug = true
          else
            ::Rails.application.config.assets.debug = false
          end

          # https://www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
          path = Assets.compute_asset_path(asset)

          puts "get: #{path}"
          get path
        end
      end
    end
  end
end
