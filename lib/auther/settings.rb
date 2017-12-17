# frozen_string_literal: true

module Auther
  # Represents Auther settings.
  class Settings
    attr_reader :title, :label, :secret, :accounts, :auth_url, :logger

    # rubocop:disable Metrics/ParameterLists
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
    # rubocop:enable Metrics/ParameterLists

    def find_account name
      accounts.find { |account| account.fetch(:name) == name }
    end
  end
end
