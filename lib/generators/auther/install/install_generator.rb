module Auther
  # Install generator for adding Auther support to existing application.
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), "..", "templates")

    desc "Installs Auther settings and routes."
    def install
      install_initializer
      add_routes
    end

    private

    def install_initializer
      template File.join("config", "initializers", "auther.rb"), File.join("config", "initializers", "auther.rb")
    end

    def add_routes
      route %(delete "/logout", to: "auther/session#destroy", as: "logout")
      route %(get "/login", to: "auther/session#new", as: "login")
      route %(mount Auther::Engine => "/auther")
    end
  end
end
