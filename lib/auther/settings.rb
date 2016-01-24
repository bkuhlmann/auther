# frozen_string_literal: true

module Auther
  # Represents Auther settings.
  class Settings
    attr_reader :title, :label, :secret, :accounts, :auth_url, :logger

    def initialize title: "Authorization",
                   label: "Authorization",
                   secret: "",
                   accounts: [],
                   auth_url: "/login",
                   logger: Auther::NullLogger.new(STDOUT)

      @title = title
      @label = label
      @secret = secret
      @accounts = accounts
      @auth_url = auth_url
      @logger = logger
    end

    def find_account name
      accounts.detect { |account| account.fetch(:name) == name }
    end
  end
end
