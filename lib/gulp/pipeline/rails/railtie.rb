require 'rails'
require 'rails/railtie'
require 'action_controller/railtie'
require 'active_support/core_ext/module/remove_method'
require 'set'

require 'gulp/pipeline/rails/assets'
require 'gulp/pipeline/rails/helper'

module Rails
  class Application
    # Hack: We need to remove Rails' built in config.assets so we can do our own thing.
    class Configuration
      remove_possible_method :assets
    end

    # Undefine Rails' assets method before redefining it, to avoid warnings.
    remove_possible_method :assets
    remove_possible_method :assets=

    attr_accessor :assets
  end
end

module Gulp
  module Pipeline
    module Rails

      # class Engine < ::Rails::Engine
      #   config.serve_static_files = false
      #   config.middleware.delete 'ActionDispatch::Static'
      # end

      class Railtie < ::Rails::Railtie
        config.serve_static_files = false
        config.assets = ActiveSupport::OrderedOptions.new
        config.assets.enabled = false
        config.assets.debug = false
        config.assets.digest_prefix = 'assets/digest'
        config.assets.debug_prefix = 'assets/debug'

        # We don't use this, but rails/engine.rb `append_assets_path` blows up without presenting this as a configurable option
        config.assets.paths = []

        # rake_tasks do |app|
        #   require 'gulp/pipeline/rails/task'
        #   Gulp::Pipeline::Rails::Task.new(app)
        # end

        config.after_initialize do |app|
          config = app.config

          serve_static = (config.methods.include?(:public_file_server) ? config.public_file_server.enabled : false) || config.serve_static_files

          if (!serve_static)
            ::Rails.logger.info 'Static file serving is off, this means you must have static file serving configured with your web server pointed at the public directory.  If this is not desired, please change this in your application.rb: config.public_file_server.enabled (or config.serve_static_files for rails < 5).'
          end


          # now require our patches for the common items that are hard linked to '/assets'
          require 'gulp/pipeline/rails/patches'

          ActiveSupport.on_load(:action_view) do
            include Gulp::Pipeline::Rails::Helper
          end

          # if trailblazer, need to override this helper directly for #compute_asset_path
          # if defined?(Cell::Concept)
          #   module ActionView
          #     module Helpers
          #       module AssetUrlHelper
          #         def self.included(base)
          #           base.include Gulp::Pipeline::Rails::Helper
          #         end
          #       end
          #     end
          #   end
          # end
        end
      end
    end
  end
end
