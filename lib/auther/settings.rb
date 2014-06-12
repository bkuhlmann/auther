module Auther
  class Settings
    attr_reader :title, :label, :secret, :accounts, :auth_url, :logger

    def initialize options = {}
      @title = options.fetch :title, "Authorization"
      @label = options.fetch :title, "Authorization"
      @secret = options.fetch :secret, nil
      @accounts = options.fetch :accounts, []
      @auth_url = options.fetch :auth_url, "/login"
      @logger = options.fetch :logger, Auther::NullLogger.new(STDOUT)
    end

    def find_account name
      accounts.detect { |account| account.fetch(:name) == name }
    end
  end
end
