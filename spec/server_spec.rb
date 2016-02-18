require 'rails_helper'

require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      describe Server, type: :request do


        shared_examples_for 'asset' do
          it 'valid' do
            assert_ok('favicon.ico', :image, debug)
          end

          it 'existing email' do
            assert_not_found('foo', :image, debug)
          end
        end


        context 'debug' do
          let(:debug) { true }
          it_behaves_like 'asset'
        end

        context 'debug' do
          let(:debug) { false }
          it_behaves_like 'asset'
        end

        private

        def assert_not_found(asset, type, debug)
          send_request(asset, type, debug)
          expect(response).to be_not_found
        end

        def assert_ok(asset, type, debug)
          send_request(value, fixture_class, attribute_name)
          expect(response).to be_success
        end

        def send_request(asset, type, debug)

          # reset the cached values in assets
          Assets.reset

          file = asset
          if debug
            file = lookup manifest
          end

          # https://www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
          get Asset.compute_asset_path(asset, {type: type})
        end
      end
    end
  end
end
