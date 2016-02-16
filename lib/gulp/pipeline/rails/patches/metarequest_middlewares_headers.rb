require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      module Patches
        module MetaRequestMiddlewaresHeaders
          def asset?(path)
            @app_config.respond_to?(:assets) && Assets.path_starts_with?(path)
          end
        end
      end
    end
  end
end
