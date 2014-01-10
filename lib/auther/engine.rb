module Auther
  class Engine < ::Rails::Engine
    isolate_namespace Auther

    # Set defaults. Can be overwritten in app config.
    config.auther_settings = {}

    initializer "auther.initialize" do |app|
      # Initialize Gatekeeper middleware.
      app.config.app_middleware.use Auther::Gatekeeper, app.config.auther_settings
    end
  end
end
