# frozen_string_literal: true

module Auther
  # The main engine.
  class Engine < ::Rails::Engine
    isolate_namespace Auther

    config.auther_settings = {}
    config.action_view.field_error_proc = proc { |html_tag, _| html_tag.html_safe }

    config.to_prepare do
      Dir.glob(Engine.root + "app/presenters/**/*.rb").each do |presenter|
        require_dependency presenter
      end
    end

    initializer "auther.initialize" do |app|
      app.config.assets.precompile.append "auther/application.css" unless Rails.env.test?
      app.config.app_middleware.use Gatekeeper, app.config.auther_settings
      app.config.filter_parameters += %i[login password]
    end
  end
end
