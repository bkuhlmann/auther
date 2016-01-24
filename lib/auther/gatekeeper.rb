# frozen_string_literal: true

module Auther
  # Rack middleware that guards access to sensitive routes.
  class Gatekeeper
    attr_reader :application, :environment, :settings

    delegate :logger, to: :settings

    def initialize application, settings = {}
      @application = application
      @settings = Auther::Settings.new settings
    end

    def call environment
      @environment = environment

      if authorized?(request.path)
        application.call environment
      else
        session[Auther::Keymaster.redirect_url_key] = request.path
        denied_response = response
        denied_response.redirect settings.auth_url
        denied_response.finish
      end
    end

    private

    def session
      environment.fetch "rack.session"
    end

    def request
      Rack::Request.new environment
    end

    def response
      status, headers, body = application.call environment
      Rack::Response.new body, status, headers
    end

    def log_info message
      id = "[#{Auther::Keymaster.namespace}]"
      logger.info [id, message].join(": ")
    end

    def log_authentication authenticated, account_name
      if authenticated
        log_info %(Authentication passed. Account: "#{account_name}".)
      else
        log_info %(Authentication failed! Account: "#{account_name}".)
      end
    end

    def log_authorization authorized, account_name, blacklist, request_path
      details = %(Account: "#{account_name}". Blacklist: #{blacklist}. Request Path: "#{request_path}".)

      if authorized
        log_info %(Authorization passed. #{details})
      else
        log_info %(Authorization failed! #{details})
      end
    end

    def find_account
      session["auther_init"] = true # Force session to initialize.
      account_name = Auther::Keymaster.get_account_name session
      account = settings.find_account account_name

      account ? log_info("Account found.") : log_info("Account unknown.")
      account
    end

    def clean_paths paths
      paths.map { |path| path.chomp "/" }
    end

    def blacklisted_paths
      paths = settings.accounts.map { |account| clean_paths account.fetch(:paths) }
      paths.flatten.uniq
    end

    def blacklisted_matched_paths path
      blacklisted_paths.select { |blacklisted_path| path.include? blacklisted_path }
    end

    def account_authenticated? account
      keymaster = Auther::Keymaster.new account.fetch(:name)
      cipher = Auther::Cipher.new settings.secret

      session_login = cipher.decrypt session[keymaster.login_key]
      session_password = cipher.decrypt session[keymaster.password_key]
      account_login = cipher.decrypt account.fetch(:encrypted_login)
      account_password = cipher.decrypt account.fetch(:encrypted_password)

      session_login == account_login && session_password == account_password
    end

    def authenticated? account
      authenticated = account_authenticated? account
      log_authentication authenticated, account.fetch(:name)
      authenticated
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      log_info %(Authentication failed! Invalid credential(s) for "#{account.fetch :name}" account.)
      false
    end

    def account_authorized? account, path
      all_paths = blacklisted_paths
      account_paths = clean_paths account.fetch(:paths)
      restricted_paths = all_paths - account_paths

      authorized = !restricted_paths.include?(path)
      log_authorization authorized, account.fetch(:name), all_paths, request.path
      authorized
    end

    def authorized? path
      if blacklisted_matched_paths(path).any?
        log_info %(Requested path "#{request.path}" found in blacklisted paths: #{blacklisted_paths}.)
        account = find_account
        account && authenticated?(account) && account_authorized?(account, path)
      else
        true
      end
    end
  end
end
