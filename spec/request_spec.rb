require 'rails_helper'

require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      describe Railtie, type: :request do

        context 'debug' do
          let(:debug) { true }
          it 'valid' do
            assert_ok('foo/bar/startransparent.gif', debug)
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

          it 'css has un-digested bg image' do
            assert_undigested('application.css', 'foo/bar/startransparent.gif')
          end

          it 'js has un-digested bg image' do
            assert_undigested('application.js', 'foo/bar/startransparent.gif')
          end

          def assert_undigested(content_path, path)
            content = assert_ok(content_path, debug)
            expect(content).to include(path)
          end
        end

        context 'digest' do
          let(:debug) { false }

          it 'valid' do
            assert_ok('foo/bar/startransparent.gif', debug)
            assert_ok('favicon.ico', debug)
            assert_ok('application.css', debug)
            assert_ok('application.js', debug)
          end

          it 'not found' do
            expect { assert_not_found('foo.png', debug) }.to raise_error /not found in the manifest/
          end

          it 'js sourcemap should not be found in manifest' do
            expect { assert_not_found('application.js.map', debug) }.to raise_error /not found in the manifest/
          end

          it 'css has digested bg image' do
            assert_digested('application.css', 'foo/bar/startransparent.gif')
          end

          it 'js has digested bg image' do
            assert_digested('application.js', 'foo/bar/startransparent.gif')
          end

          def assert_digested(content_path, path)
            content = assert_ok(content_path, debug)

            # std path should not be included
            expect(content).not_to include(path)

            # digest path should be
            digest_path = Assets.manifest_path(path)
            expect(content).to include(digest_path)
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
          response.body
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
