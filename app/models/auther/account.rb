# frozen_string_literal: true

require "active_model"

module Auther
  # Represents an authenticatable account.
  class Account
    include ActiveModel::Validations

    attr_accessor :name,
                  :encrypted_login,
                  :encrypted_password,
                  :paths,
                  :authorized_url,
                  :deauthorized_url

    validates :name, :encrypted_login, :encrypted_password, presence: true
    validates :paths, presence: {
      unless: ->(account) { account.paths.is_a? Array },
      message: "must be an array"
    }

    # rubocop:disable Style/OptionHash
    def initialize options = {}
      @name = options.fetch :name, nil
      @encrypted_login = options.fetch :encrypted_login, nil
      @encrypted_password = options.fetch :encrypted_password, nil
      @paths = options.fetch :paths, []
      @authorized_url = options.fetch :authorized_url, nil
      @deauthorized_url = options.fetch :deauthorized_url, nil
    end
    # rubocop:enable Style/OptionHash
  end
end
