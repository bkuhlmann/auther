module Auther
  class Engine < ::Rails::Engine
    isolate_namespace Auther

    # Set defaults. Can be overwritten in app config.
    config.auther_settings = {}

    # Add jQuery assets.
    jquery_gem_path = Gem.loaded_specs["jquery-rails"].full_gem_path
    config.assets.paths << "#{jquery_gem_path}/vendor/assets/javascripts"

    # Add Zurb Foundation assets.
    foundation_gem_path = Gem.loaded_specs["foundation-rails"].full_gem_path
    config.assets.paths << "#{foundation_gem_path}/vendor/assets/stylesheets"
    config.assets.paths << "#{foundation_gem_path}/vendor/assets/javascripts"

    initializer "auther.initialize" do |app|
      # Configure log filter parameters.
      app.config.filter_parameters += [:login, :password]

      # Initialize Gatekeeper middleware.
      app.config.app_middleware.use Auther::Gatekeeper, app.config.auther_settings
    end
  end
end
