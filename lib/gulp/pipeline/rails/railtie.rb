require 'rails'
require 'rails/railtie'
require 'action_controller/railtie'
require 'active_support/core_ext/module/remove_method'
require 'set'

require 'gulp/pipeline/rails/server'
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
      class Railtie < ::Rails::Railtie

        config.assets = ActiveSupport::OrderedOptions.new
        config.assets.debug = false
        config.assets.digest_prefix = 'assets/digest'
        config.assets.debug_prefix = 'assets/debug'

        # Maps asset types to public directory.  If unmapped, there will be nothing added to the path.  This must match the physical layout of the public directory under #{config.assets.digest_prefix} and #{config.assets.debug_prefix}
        config.assets.type_directory_map = {}
        # config.assets.type_directory_map = {
        #   audio: 'audios',
        #   font: 'fonts',
        #   image: 'images',
        #   javascript: 'javascripts',
        #   stylesheet: 'stylesheets',
        #   video: 'videos'
        # }


        # We don't use this, but rails/engine.rb `append_assets_path` blows up without presenting this as a configurable option
        config.assets.paths = []

        # rake_tasks do |app|
        #   require 'gulp/pipeline/rails/task'
        #   Gulp::Pipeline::Rails::Task.new(app)
        # end

        config.after_initialize do |app|
          config = app.config

          app.assets = Server.new(app)
          app.routes.prepend do
            # for each asset path, add a route to our server - e.g. this may be /images or /digest/images depending on `config.assets.debug`.  This means that these paths are stored and served as-is, enabling the greatest compatibility with external file serving.
            prefixes = config.assets.type_directory_map.values || []
            if (prefixes.length <= 0)
              path = Assets.base_path
              puts "Mounting gulp-pipeline-rails server to #{path}"
              mount app.assets => path
            else
              prefixes.each do |prefix|
                mount app.assets => Assets.mount_path(prefix)
              end
            end
          end

          # now require our patches for the common items that are hard linked to '/assets'
          require 'gulp/pipeline/rails/patches'

          ActiveSupport.on_load(:action_view) do
            include Gulp::Pipeline::Rails::Helper
          end
        end
      end
    end
  end
end
