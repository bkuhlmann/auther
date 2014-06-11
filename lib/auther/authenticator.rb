module Auther
  class Authenticator

    def initialize secret, account_model, account_presenter
      @cipher = Auther::Cipher.new secret
      @account_model = account_model
      @account_presenter = account_presenter
    end

    def authenticated?
      account_model.valid? &&
      account_presenter.valid? &&
      authentic_name? &&
      authentic_login? &&
      authentic_password?
    end

    private

    attr_reader :cipher, :account_model, :account_presenter

    def authentic? encrypted_value, value, error_name
      # FIX: Extract conditional logic to a separate method.
      begin
        if cipher.decrypt(encrypted_value) == value
          true
        else
          account_presenter.errors.add error_name, "is invalid"
          false
        end
      rescue ActiveSupport::MessageVerifier::InvalidSignature => error
        # TODO: Add logger.
        false
      end
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
