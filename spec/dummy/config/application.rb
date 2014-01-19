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
      title: "Dummy",
      label: "Dummy",
      accounts: [
        {
          name: "test",
          login: "WWNhTlk3VGU4dXc1bjFmU2FZYmM5UmxZYXEzSyt6TDlITmlXQ3MxcXk4RT0tLUlVRXRlWE81T3dLc1lrOCtUbDdYeVE9PQ==--81991e25d072d0904af97b9d114d4e543b6bcbe2",
          password: "VEtiVGwrYko0eXdhL1dnZ0d0MFFhWmI4UEkrL3A4NUNoNnZPNlBtQkwwZz0tLVpxSUwvYkV4NWVUNERuSzJBNFNkWmc9PQ==--9028c12deb299b659d1eaeac5b2ff46136138f7c",
          paths: ["/portal"]
        }
      ],
      secret: "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb",
      auth_url: "/session/new"
    }
  end
end

