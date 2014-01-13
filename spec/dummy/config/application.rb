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
          login: "N3JzR213WlBISDZsMjJQNkRXbEVmYVczbVdnMHRYVHRud29lOWRCekp6ST0tLWpFMkROekUvWDBkOHZ4ZngxZHV6clE9PQ==--cd863c39991fa4bb9a35de918aa16da54514e331",
          password: "cHhFSStjRm9KbEYwK3ZJVlF2MmpTTWVVZU5acEdlejZsZEhjWFJoQWxKND0tLTE3cmpXZVBQdW5VUW1jK0ZSSDdLUnc9PQ==--f51171174fa77055540420f205e0dd9d499cfeb6",
          paths: ["/portal"]
        }
      ],
      secret: "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb",
      auth_url: "/session/new"
    }
  end
end

