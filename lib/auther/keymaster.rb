module Auther
  # Provides access to setting keys.
  class Keymaster
    attr_reader :account_name

    def self.namespace
      "auther"
    end

    def self.redirect_url_key options = {}
      [namespace, "redirect", "url"] * options.fetch(:delimiter, "_")
    end

    def self.get_account_name session = {}
      matching_keys = session.keys.select { |key| key.to_s =~ /auther.+login/ }
      key = matching_keys.first || ""
      key.gsub("#{namespace}_", "").gsub "_login", ""
    end

    def self.get_account_login session = {}
      account_name = get_account_name session
      session[new(account_name).login_key]
    end

    def initialize account_name = nil
      @account_name = account_name
    end

    def login_key
      build_key "login"
    end

    def password_key
      build_key "password"
    end

    private

    def build_key key_name, options = {}
      [self.class.namespace, account_name, key_name].compact * options.fetch(:delimiter, "_")
    end
  end
end
