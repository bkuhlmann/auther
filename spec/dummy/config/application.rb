require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require
require "auther"

module Dummy
  class Application < Rails::Application
    config.assets.compile = false
  end
end
