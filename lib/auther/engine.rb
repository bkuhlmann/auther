module Auther
  # The main engine.
  class Engine < ::Rails::Engine
    isolate_namespace Auther

    # Set defaults. Can be overwritten in app config.
    config.auther_settings = {}

    # Autoload presenters
    config.to_prepare do
      Dir.glob(Engine.root + "app/presenters/**/*.rb").each do |presenter|
        require_dependency presenter
      end
    end

    initializer "auther.initialize" do |app|
      asset_paths = app.config.assets.paths

      # Add jQuery assets.
      add_asset_paths asset_paths, "jquery-rails", "javascripts"

      # Configure log filter parameters.
      app.config.filter_parameters += [:login, :password]

      # Initialize Gatekeeper middleware.
      app.config.app_middleware.use Auther::Gatekeeper, app.config.auther_settings
    end

    private

    def full_gem_path name
      Gem.loaded_specs[name].full_gem_path
    end

    def add_asset_paths paths, name, directory
      paths << "#{full_gem_path name}/vendor/assets/#{directory}"
    end
  end
end
