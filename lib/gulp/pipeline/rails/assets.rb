module Gulp
  module Pipeline
    module Rails
      class Assets
        class << self

          # Computes asset path to public directory. We override this in the Helper to resolve
          # either debug or digest assets.
          #
          # source: favicon.ico
          # options: {type: :image}
          def compute_asset_path(source)

            # get the relative file path without a leading slash (empty dir join adds leading slash)
            if (debug)
              path = File.join('/', base_path, source)
            else
              manifested = manifest[source]
              raise "#{source} not found in the manifest.  Perhaps you need to recreate it by running gulp and the configured digest task." if manifested.nil?
              path = File.join('/', base_path, manifested)
            end
            path
          end

          # Yield a digest path with respect to debug turned on or off
          def base_path
            if debug
              "/#{debug_prefix}/"
            else
              "/#{digest_prefix}/"
            end
          end

          def mount_path(prefix)
            "/#{base_path}#{prefix}"
          end

          def path_matches?(path)
            (path =~ matches_regex) == 0
          end

          def path_starts_with?(path)
            (path =~ starts_with_regex) == 0
          end

          def manifest
            return @_manifest unless @_manifest.nil?

            # read manifest and cache it
            path = ::Rails.application.root.join('public', digest_prefix, 'rev-manifest.json')
            # if not debug, require manifest
            raise "#{path} not found.  Run `gulp digest` or `gulp rev`." unless File.exists?(path)
            @_manifest = JSON.parse(File.read(path))
          end

          # testing method to clear cache of values
          def reset
            # self.instance_variable_names.each do |var_name|
            #   self.instance_variable_set var_name, nil
            # end
            instance_variables.each { |name, value|
              instance_variable_set(name, nil)
            }
          end

          private

          # lazy load/cache regex
          def matches_regex
            @_matches_regex ||= %r{\A/#{base_path}\z}
          end

          # lazy load/cache regex
          def starts_with_regex
            @_starts_with_regex ||= %r{\A/#{base_path}}
          end

          def debug
            @_debug ||= ::Rails.application.config.assets.debug
          end

          def digest_prefix
            @_digest_prefix ||= ::Rails.application.config.assets.digest_prefix
          end

          def debug_prefix
            @_debug_prefix ||= ::Rails.application.config.assets.debug_prefix
          end
        end
      end
    end
  end
end
