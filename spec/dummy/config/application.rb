require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "auther"

module Dummy
  class Application < Rails::Application
    config.auther_settings = {
      accounts: [
        {
          name: "test",
          login: "test@test.com",
          password: "password",
          paths: ["/portal"]
        }
      ],
      auth_url: "/session/new"
    }
  end
end

