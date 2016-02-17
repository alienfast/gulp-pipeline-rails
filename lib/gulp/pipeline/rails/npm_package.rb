#
# Helper class to access attributes of package.json and dependencies' packages.
#   For example, to get the jquery version for output in a script tag with a cdn, you could use:
#     npmPackage = NpmPackage.new
#     npmPackage.dependency_version('jquery')
#
module Gulp
  module Pipeline
    module Rails
      class NpmPackage

        def initialize(package = nil, app_root = ::Rails.application.root)
          @@node_modules_path ||= app_root.join('node_modules')
          @npmPackages = {}

          if package.nil?
            @name = 'application'
            package_root = app_root
          else
            @name = package
            package_root = @@node_modules_path.join(package)
          end
          package_file = package_root.join('package.json')
          raise "Failed to find #{@name}'s package.json at #{package_file}" unless File.exists?(package_file)
          @contents = JSON.parse(File.read(package_file))
        end

        # return direct access results i.e. npmPackage.version
        def method_missing(name, *args, &block)
          @contents[name.to_s] || nil
        end

        def dependency_version(package)
         dependency_package(package).version
        end

        # Find/cache dependency package
        def dependency_package(package)
          npmPackage = @npmPackages[package]
          return npmPackage unless npmPackage.nil?

          npmPackage = NpmPackage.new(package)
          @npmPackages[package] = npmPackage
          npmPackage
        end
      end
    end
  end
end