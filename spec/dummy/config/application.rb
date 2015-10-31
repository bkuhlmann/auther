require File.expand_path("../boot", __FILE__)

# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require
require "auther"

module Dummy
  # The dummy application for testing purposes.
  class Application < Rails::Application
    config.assets.compile = false
  end
end
