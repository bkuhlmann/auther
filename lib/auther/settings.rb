# frozen_string_literal: true

module Auther
  # Represents Auther settings.
  Settings = Struct.new :title, :label, :secret, :accounts, :url, :logger, keyword_init: true do
    def initialize(*)
      super

      self[:title] ||= "Authorization"
      self[:label] ||= "Authorization"
      self[:secret] ||= ""
      self[:accounts] ||= []
      self[:url] ||= "/login"
      self[:logger] ||= LOGGER
    end

    def find_account(name) = accounts.find { |account| account.fetch(:name) == name }
  end
end
