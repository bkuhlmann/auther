require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "auther"

module Dummy
  class Application < Rails::Application
    config.assets.initialize_on_precompile = false
  end
end
