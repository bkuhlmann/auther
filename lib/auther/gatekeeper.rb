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
      account = settings.fetch(:accounts).detect { |account| account.fetch(:name) == account_name }

      account ? info("Account found.") : info("Account unknown.")
      account
    end

    def clean_paths paths
      paths.map { |path| path.chomp '/' }
    end

    def blacklisted_paths accounts
      paths = accounts.map { |account| clean_paths account.fetch(:paths) }
      paths.flatten.uniq
    end

    def blacklisted_matched_paths accounts, path
      paths = blacklisted_paths accounts
      paths.select { |blacklisted_path| path.include? blacklisted_path }
    end

    def blacklisted_account? account, path
      paths = clean_paths account.fetch(:paths)
      blacklisted = paths.include? path

      if blacklisted
        info %(Authorization failed! Requested path "#{request.path}" blacklisted by "#{account.fetch :name}" account blacklist: #{paths}.)
      else
        info %(Authorization passed. Requested path "#{request.path}" not found in "#{account.fetch :name}" account blacklist: #{paths}.)
      end

      blacklisted
    end

    def authenticated? account
      keymaster = Auther::Keymaster.new account.fetch(:name)
      cipher = Auther::Cipher.new settings.fetch(:secret)

      begin
        session_login = cipher.decrypt session[keymaster.login_key]
        session_password = cipher.decrypt session[keymaster.password_key]
        account_login = cipher.decrypt account.fetch(:login)
        account_password = cipher.decrypt account.fetch(:password)
        authenticated = session_login == account_login && session_password == account_password

        if authenticated
          info %(Authentication passed. The "#{account.fetch :name}" account is authenticated.)
        else
          info %(Authentication failed! Unable to authenticate the "#{account.fetch :name}" account.)
        end

        authenticated
      rescue ActiveSupport::MessageVerifier::InvalidSignature => error
        info %(Authentication failed! Invalid credential(s) for "#{account.fetch :name}" account.)
        false
      end
    end

    def authorized? path
      accounts = settings.fetch :accounts
      all_blacklisted_paths = blacklisted_paths settings.fetch(:accounts)

      if blacklisted_matched_paths(accounts, path).any?
        info %(Requested path "#{request.path}" found in blacklisted paths: #{all_blacklisted_paths}.)
        account = find_account
        account && authenticated?(account) && !blacklisted_account?(account, path)
      else
        true
      end
    end
  end
end
