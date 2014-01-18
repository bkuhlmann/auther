module Auther
  class Engine < ::Rails::Engine
    isolate_namespace Auther

    # Set defaults. Can be overwritten in app config.
    config.auther_settings = {}

    # Add jQuery assets.
    config.assets.paths << "#{Gem.loaded_specs['jquery-rails'].full_gem_path}/vendor/assets/javascripts"

    # Add Zurb Foundation assets.
    config.assets.paths << "#{Gem.loaded_specs['foundation-rails'].full_gem_path}/vendor/assets/stylesheets"
    config.assets.paths << "#{Gem.loaded_specs['foundation-rails'].full_gem_path}/vendor/assets/javascripts"

    initializer "auther.initialize" do |app|
      # Initialize Gatekeeper middleware.
      app.config.app_middleware.use Auther::Gatekeeper, app.config.auther_settings
    end
  end
end
