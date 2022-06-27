# frozen_string_literal: true

module Auther
  # Credentials generator for new secret, login, and password.
  class CredentialsGenerator < ::Rails::Generators::Base
    desc "Generate Auther secret, login, and password credentials."
    def credentials
      puts "Welcome to the Auther credentials generator.\n"

      login = ask "  Enter admin login:", echo: false
      password = ask "\n  Enter admin password:", echo: false
      identity = Cipher.generate login, password

      display identity
    end

    private

    def display identity
      puts "\n\nHere are your credentials:\n"

      say <<~MESSAGE.gsub(/^/, "  "), :green
        AUTHER_SECRET=#{identity.fetch :secret}
        AUTHER_ADMIN_LOGIN=#{identity.fetch :login}
        AUTHER_ADMIN_PASSWORD=#{identity.fetch :password}
      MESSAGE

      say "\nReminder: Do not add these credentials to source control.", :yellow
    end
  end
end
