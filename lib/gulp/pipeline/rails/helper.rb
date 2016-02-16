module Gulp
  module Pipeline
    module Rails
      module Helper
        # Maps asset types to public directory.
        ASSET_PUBLIC_DIRECTORIES = {
          audio:      '/audios',
          font:       '/fonts',
          image:      '/images',
          javascript: '/javascripts',
          stylesheet: '/stylesheets',
          video:      '/videos'
        }

        # Computes asset path to public directory. Plugins and
        # extensions can override this method to point to custom assets
        # or generate digested paths or query strings.
        def compute_asset_path(source, options = {})
          Assets.compute_asset_path(source, options)
        end
      end
    end
  end
end
