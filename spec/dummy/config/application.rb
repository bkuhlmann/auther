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
          secret: "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb",
          paths: ["/portal"]
        }
      ],
      auth_url: "/session/new"
    }
  end
end

