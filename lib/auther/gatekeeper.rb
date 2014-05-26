module Auther
  class Gatekeeper
    attr_reader :application, :environment, :settings, :logger

    def initialize application, settings = []
      @application = application
      @settings = settings
      @logger = @settings.fetch :logger, Auther::NullLogger.new(STDOUT)
    end

    def call environment
      @environment = environment

      if authorized?(request.path)
        application.call environment
      else
        session[Auther::Keymaster.redirect_url_key] = request.path
        denied_response = response
        denied_response.redirect settings[:auth_url]
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

    def info message
      id = "[#{Auther::Keymaster.namespace}]"
      logger.info [id, message].join(": ")
    end

    def find_account
      session["auther_init"] = true # Force session to initialize.
      account_name = Auther::Keymaster.get_account_name session
      settings.fetch(:accounts).select { |account| account.fetch(:name) == account_name }.first
    end

    def clean_paths paths
      paths.map { |path| path.chomp '/' }
    end

    def blacklisted_path? path
      blacklisted_accounts_paths = settings.fetch(:accounts).map do |account|
        clean_paths account.fetch(:paths)
      end

      blacklisted_accounts_paths.flatten!.uniq!
      blacklisted_matched_paths = blacklisted_accounts_paths.select { |blacklisted_path| path.include? blacklisted_path }

      if blacklisted_matched_paths.any?
        info %(Requested path "#{request.path}" detected in blacklisted paths: #{blacklisted_accounts_paths}.)
        true
      else
        false
      end
    end

    def blacklisted_account? account, path
      if clean_paths(account.fetch(:paths)).include?(path)
        info %(Requested path "#{request.path}" blacklisted for "#{account.fetch :name}" account.)
        true
      else
        false
      end
    end

    def authenticated? account
      keymaster = Auther::Keymaster.new account.fetch(:name)
      cipher = Auther::Cipher.new settings.fetch(:secret)

      begin
        session_login = cipher.decrypt session[keymaster.login_key]
        session_password = cipher.decrypt session[keymaster.password_key]
        account_login = cipher.decrypt account.fetch(:login)
        account_password = cipher.decrypt account.fetch(:password)

        session_login == account_login && session_password == account_password
      rescue ActiveSupport::MessageVerifier::InvalidSignature => error
        false
      end
    end

    def authorized? path
      if blacklisted_path?(path)
        account = find_account
        account && authenticated?(account) && !blacklisted_account?(account, path)
      else
        true
      end
    end
  end
end
