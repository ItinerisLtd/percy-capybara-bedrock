require 'percy/capybara'
require 'digest'
require 'pathname'

module Percy
  module Capybara
    module Bedrock
      class Loader < Loaders::BaseLoader
        RESOURCE_PATHS = [
          '/app/mu-plugins',
          '/app/plugins',
          '/app/themes',
          '/app/uploads',
          '/wp',
        ].freeze

        SKIP_RESOURCE_EXTENSIONS = [
          '.gz',
          '.htm',
          '.html',
          '.json',
          '.lock',
          '.log',
          '.map',
          '.md',
          '.php',
          '.phtml',
          '.rar',
          '.rb',
          '.sql',
          '.txt',
          '.xml',
          '.zip',
          '.gemspec',
        ].freeze

        SKIP_RESOURCE_BASENAMES = [
          '.DS_Store',
          '.editorconfig',
          '.eslintrc.js',
          '.gitignore',
          'Gemfile',
          'LICENSE',
          'Rakefile',
        ].freeze

        SKIP_RESOURCE_PATHS = [
          '/.cache-loader/',
          '/.cache/',
          '/.caches/',
          '/.circleci/',
          '/.git/',
          '/.github/',
          '/build/',
          '/cache/',
          '/caches/',
          '/doc/',
          '/docs/',
          '/log/',
          '/logs/',
          '/node_modules/',
          '/tmp/',
          '/vendor/',
          '/wp/wp-content/themes/',
          'resources/assets/',
        ].freeze

        attr_reader :web_root, :base_url

        def initialize(options = {})
          # @web_root should point to <bedrock>/web
          @web_root = options[:web_root]
          @base_url = options[:base_url] || '/'

          raise ArgumentError, '@web_root is required' if @web_root.nil? || @web_root == ''
          unless Pathname.new(@web_root).absolute?
            raise ArgumentError, "@web_root needs to be an absolute path. Received: #{@web_root}"
          end
          unless Dir.exist?(@web_root)
            raise ArgumentError, "@web_root provided was not found. Received: #{@web_root}"
          end

          super
        end

        def snapshot_resources
          [root_html_resource]
        end

        def build_resources
          _resources_from_dir(@web_root, base_url: @base_url)
        end

        # https://github.com/percy/percy-capybara/blob/5865d54b81eac27ffc74c839eef7425a361d6f89/lib/percy/capybara/loaders/base_loader.rb#L125
        def _resources_from_dir(root_dir, base_url: '/')
          resources = []

          resource_dirs = RESOURCE_PATHS.map do |resource_path|
            root_dir + resource_path
          end

          _find_files(resource_dirs).each do |path|
            next if skip?(path: path)

            # Replace the @web_root with the base_url to generate the resource_url
            resource_url = _uri_join(base_url, path.sub(root_dir.to_s, ''))
            sha = Digest::SHA256.hexdigest(File.read(path))
            resources << Percy::Client::Resource.new(resource_url, sha: sha, path: path)
          end

          resources
        end

        def skip?(path:)
          skip_extension?(path: path) ||
          skip_basename?(path: path) ||
          skip_path?(path: path) ||
          skip_file_size?(path: path)
        end

        def skip_extension?(path:)
          SKIP_RESOURCE_EXTENSIONS.include?(File.extname(path))
        end

        def skip_basename?(path:)
          SKIP_RESOURCE_BASENAMES.include?(File.basename(path))
        end

        def skip_path?(path:)
          SKIP_RESOURCE_PATHS.any? { |skip| path.include?(skip) }
        end

        def skip_file_size?(path:)
          File.size(path) > MAX_FILESIZE_BYTES
        end
      end
    end
  end
end
