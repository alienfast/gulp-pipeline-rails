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
          def compute_asset_path(source, options = {})
            dir = type_directory_map[options[:type]] || ''

            # get the relative file path without a leading slash (empty dir join adds leading slash)
            file = if dir.eql? '' then
                     source
                   else
                     File.join(dir, source)
                   end
            if (debug)
              path = File.join('/', base_path, file)
            else
              manifested = manifest[file]
              raise "#{source} not found in the manifest.  Perhaps you need to recreate it by running `gulp digest` or `gulp rev`" if manifested.nil?
              path = File.join('/', base_path, manifested)
            end
            path
          end

          # Yield a digest path with respect to debug turned on or off
          def base_path
            if debug
              "#{debug_prefix}/"
            else
              "#{digest_prefix}/"
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

          private

          def manifest
            return @_manifest unless @_manifest.nil?

            # read manifest and cache it
            path = ::Rails.application.root.join('public', digest_prefix, 'rev-manifest.json')
            # if not debug, require manifest
            raise "#{path} not found.  Run `gulp digest` or `gulp rev`." unless File.exists?(path)
            @_manifest = JSON.parse(File.read(path))
          end

          # lazy load/cache regex
          def matches_regex
            @_matches_regex ||= %r{\A/#{base_path}\z}
          end

          # lazy load/cache regex
          def starts_with_regex
            @_starts_with_regex ||= %r{\A/#{base_path}}
          end

          def type_directory_map
            @_type_directory_map ||= ::Rails.application.config.assets.type_directory_map
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