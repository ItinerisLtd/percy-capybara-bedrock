require "percy/capybara/bedrock/loader"
require 'capybara'
require 'capybara/poltergeist'
require 'percy/capybara'

module Percy
  module Capybara
    module Bedrock
      # Simple block runner for self-contained Capybara tests.
      #
      # Usage:
      #   Percy::Capybara::Bedrock::Anywhere.run(SERVER, WEB_ROOT, ASSETS_BASE_URL) do |page|
      #     page.visit('/')
      #     sleep(2)
      #     Percy::Capybara.snapshot(page, name: 'main page')
      #   end
      module Anywhere
        def self.run(server, web_root, assets_base_url = nil)
          if ENV['PERCY_TOKEN'].nil?
            raise 'Whoops! You need to setup the PERCY_TOKEN environment variable.'
          end

          ::Capybara.run_server = false
          ::Capybara.app_host = server
          page = ::Capybara::Session.new(:poltergeist)

          Percy::Capybara.use_loader(Loader, web_root: web_root, base_url: assets_base_url)
          build = Percy::Capybara.initialize_build

          yield(page)

          Percy::Capybara.finalize_build
          puts
          puts 'Done! Percy snapshots are now processing...'
          puts "--> #{build['data']['attributes']['web-url']}"
        end
      end
    end
  end
end
