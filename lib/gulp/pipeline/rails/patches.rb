require 'gulp/pipeline/rails/patches/route_wrapper'

module Gulp
  module Pipeline
    module Rails

      # set our paths to be regarded as internal paths
      ActionDispatch::Routing::RouteWrapper.class_eval do
        prepend Patches::RouteWrapper
      end


      if defined?(MetaRequest::Middlewares::Headers)
        require 'gulp/pipeline/rails/patches/metarequest_middlewares_headers'
        MetaRequest::Middlewares::Headers.class_eval do
          prepend Patches::MetaRequestMiddlewaresHeaders
        end
      end
    end
  end
end
