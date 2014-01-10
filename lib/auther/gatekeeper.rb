module Auther
  class Gatekeeper
    attr_reader :application, :settings

    def initialize application, settings = []
      @application = application
      @settings = settings
    end

    def call env
      session = env.fetch "rack.session"
      request_path = env["PATH_INFO"]

      if authorized?(env, request_path)
        application.call env
      else
        session[Auther::Keymaster.redirect_url_key] = request_path
        response = Rack::Response.new
        response.redirect settings[:auth_url]
        response.finish
      end
    end

    private

    def find_account env
      session = env.fetch "rack.session"
      session["auther_init"] = true # Force session to initialize.
      account_name = Auther::Keymaster.get_account_name session
      settings.fetch(:accounts).select { |account| account.fetch(:name) == account_name }.first
    end

    def blacklisted_path? path
      blacklisted_paths = settings.fetch(:accounts).map {|account| account.fetch :paths }.flatten
      blacklisted_paths.map { |blacklisted_path| path.include? blacklisted_path }.any?
    end

    def blacklisted_account? account, path
      account.fetch(:paths).include? path
    end

    def authenticated? env, account
      session = env.fetch "rack.session"
      keymaster = Auther::Keymaster.new account.fetch(:name)
      session[keymaster.login_key] == account.fetch(:login) && session[keymaster.password_key] == account.fetch(:password)
    end

    def authorized? env, path
      if blacklisted_path?(path)
        account = find_account env
        account && authenticated?(env, account) && !blacklisted_account?(account, path)
      else
        true
      end
    end
  end
end
