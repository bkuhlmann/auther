# frozen_string_literal: true

module Auther
  # Manages account authentication.
  class Authenticator
    # rubocop:disable Metrics/ParameterLists
    def initialize secret, account_model, account_presenter, logger: LOGGER
      @cipher = Auther::Cipher.new secret
      @account_model = account_model
      @account_presenter = account_presenter
      @logger = logger
    end
    # rubocop:enable Metrics/ParameterLists

    def authenticated?
      account_model.valid? &&
        account_presenter.valid? &&
        authentic_name? &&
        authentic_login? &&
        authentic_password?
    end

    private

    attr_reader :cipher, :account_model, :account_presenter, :logger

    def log_info message
      id = "[#{Auther::Keymaster.namespace}]"
      logger.info [id, message].join(": ")
    end

    def authentic? encrypted_value, value, error_name
      if cipher.decrypt(encrypted_value) == value
        true
      else
        account_presenter.errors.add error_name, "is invalid"
        false
      end
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      log_info %(Authentication failed! Invalid credential(s) for "#{account_model.name}" account.)
      false
    end

    def authentic_name?
      account_presenter.name == account_model.name
    end

    def authentic_login?
      authentic? account_model.encrypted_login, account_presenter.login, "login"
    end

    def authentic_password?
      authentic? account_model.encrypted_password, account_presenter.password, "password"
    end
  end
end
