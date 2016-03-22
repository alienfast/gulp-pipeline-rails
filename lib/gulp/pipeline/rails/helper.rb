module Gulp
  module Pipeline
    module Rails
      module Helper
        # Computes asset path to public directory. Plugins and
        # extensions can override this method to point to custom assets
        # or generate digested paths or query strings.
        def compute_asset_path(source, options = {})
          Assets.compute_asset_path(source)
        end
      end
    end
  end
end
