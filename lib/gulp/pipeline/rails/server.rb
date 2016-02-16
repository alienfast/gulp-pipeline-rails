require 'time'
require 'rack/utils'
require 'gulp/pipeline/rails/assets'

module Gulp
  module Pipeline
    module Rails
      # `Server` provides a Rack compatible `call` interface and url generation helpers.
      class Server

        def initialize(app, options = {})
          config = app.config

          @debug = config.assets.debug
          @file_server = Rack::File.new(app.root.join('public', Assets.base_path).to_s)
          @cache_duration = options[:duration] || 1
          @duration_in_seconds = duration_in_seconds
          @duration_in_words = duration_in_words
        end

        # A request for `"/assets/javascripts/foo/bar.js"` will search the public directory.
        def call(env)
          if env['REQUEST_METHOD'] != 'GET'
            return method_not_allowed_response
          end

          msg = "Served asset #{env['PATH_INFO']} -"

          # Extract the path from everything after the leading slash
          path = Rack::Utils.unescape(env['PATH_INFO'].to_s.sub(/^\//, ''))

          status, headers, body =
            if forbidden_request?(path)
              # URLs containing a `..` are rejected for security reasons.
              forbidden_response
            else
              # # If not debug, enforce/require fingerprinted url. Do we really need this or just paranoia?
              # if (!@debug)
              #   fingerprint = path_fingerprint(path)
              #   if (fingerprint.nil?)
              #     msg += ' not a manifested file'
              #     return not_found_response
              #   end
              # end

              # standard file serve
              @file_server.call(env)
            end

          # log our status
          case status
            when :ok
              logger.info "#{msg} 200 OK "
            when :not_modified
              logger.info "#{msg} 304 Not Modified "
            when :not_found
              logger.info "#{msg} 404 Not Found "
            else
              logger.info "#{msg} #{status} Unknown status message "
          end

          # add cache headers
          headers['Cache-Control'] ="max-age=#{@duration_in_seconds}, public"
          headers['Expires'] = @duration_in_words

          # return results
          [status, headers, body]

        rescue Exception => e
          logger.error "Error serving asset #{path}:"
          logger.error "#{e.class.name}: #{e.message}"
          raise
        end

        private
        def forbidden_request?(path)
          # Prevent access to files elsewhere on the file system
          #
          #     http://example.org/assets/../../../etc/passwd
          #
          path.include?('..') || absolute_path?(path)
        end

        # Public: Check if path is absolute or relative.
        #
        # path - String path.
        #
        # Returns true if path is absolute, otherwise false.
        if File::ALT_SEPARATOR
          require 'pathname'

          # On Windows, ALT_SEPARATOR is \
          # Delegate to Pathname since the logic gets complex.
          def absolute_path?(path)
            Pathname.new(path).absolute?
          end
        else
          def absolute_path?(path)
            path[0] == File::SEPARATOR
          end
        end

        # Returns a 403 Forbidden response tuple
        def forbidden_response
          [403, {'Content-Type' => 'text/plain', 'Content-Length' => '9'}, ['Forbidden']]
        end

        # Returns a 404 Not Found response tuple
        def not_found_response
          [404, {'Content-Type' => 'text/plain', 'Content-Length' => '9', 'X-Cascade' => 'pass'}, ['Not found']]
        end

        def method_not_allowed_response
          [405, {'Content-Type' => 'text/plain', 'Content-Length' => '18'}, ['Method Not Allowed']]
        end

        def logger
          ::Rails.logger
        end

        def duration_in_words
          (Time.now + duration_in_seconds).strftime '%a, %d %b %Y %H:%M:%S GMT'
        end

        def duration_in_seconds
          (60 * 60 * 24 * 365 * @cache_duration).to_i
        end

        # def path_fingerprint(path)
        #   path[/-([0-9a-f]{7,128})\.[^.]+\z/, 1]
        # end
      end
    end
  end
end
