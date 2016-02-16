require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      module Patches
        module RouteWrapper

          def internal_assets_path?
            Assets.path_matches? path
          end

          def internal?
            super || internal_assets_path?
          end
        end
      end
    end
  end
end
