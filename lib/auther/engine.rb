require "bourbon"
require "neat"

module Auther
  # The main engine.
  class Engine < ::Rails::Engine
    isolate_namespace Auther

    config.auther_settings = {}
    config.action_view.field_error_proc = proc { |html_tag, _| html_tag.html_safe }

    config.to_prepare do
      Dir.glob(Engine.root + "app/presenters/**/*.rb").each { |presenter| require_dependency presenter }
    end

    initializer "auther.initialize" do |app|
      app.config.app_middleware.use Gatekeeper, app.config.auther_settings
      app.config.filter_parameters += [:login, :password]
    end
  end
end
