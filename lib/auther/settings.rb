module Auther
  class Settings
    attr_reader :title, :label, :secret, :accounts, :auth_url, :logger

    def initialize title: "Authorization", label: "Authorization", secret:, accounts:, auth_url: "/login", logger: Auther::NullLogger.new(STDOUT)
      @title = title
      @label = label
      @secret = secret
      @accounts = accounts
      @auth_url = auth_url
      @logger = logger
    end
  end
end
