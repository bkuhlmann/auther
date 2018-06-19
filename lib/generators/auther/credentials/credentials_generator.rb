# frozen_string_literal: true

module Auther
  # Credentials generator for new secret, login, and password.
  class CredentialsGenerator < ::Rails::Generators::Base
    desc "Generate Auther secret, login, and password credentials."
    # :reek:TooManyStatements
    def credentials
      puts "Welcome to the Auther credentials generator.\n"

      login = ask "  Enter admin login:", echo: false
      password = ask "\n  Enter admin password:", echo: false
      credentials = Cipher.generate login, password

      puts "\n\nHere are your credentials:\n"

      say "  AUTHER_SECRET=#{credentials.fetch :secret}\n" \
          "  AUTHER_ADMIN_LOGIN=#{credentials.fetch :login}\n" \
          "  AUTHER_ADMIN_PASSWORD=#{credentials.fetch :password}",
          :green

      say "\nReminder: Do not add these credentials to source control.", :yellow
    end
  end
end
