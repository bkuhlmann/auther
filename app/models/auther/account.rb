require "active_model"

module Auther
  class Account
    include ActiveModel::Validations

    attr_accessor :name, :login, :encrypted_login, :password, :encrypted_password, :paths, :authorized_url

    validates :name, presence: true
    validates :paths, presence: {unless: lambda { |account| account.paths.is_a? Array }, message: "must be an array"}

    def initialize options = {}
      @name = options.fetch :name, nil
      @login = options.fetch :login, nil
      @encrypted_login = options.fetch :encrypted_login, nil
      @password = options.fetch :password, nil
      @encrypted_password = options.fetch :encrypted_password, nil
      @paths = options.fetch :paths, []
      @secret = options.fetch :secret, nil
      @authorized_url = options.fetch :authorized_url, nil
      @deauthorized_url = options.fetch :deauthorized_url_url, nil
    end

    def valid?
      super && authorized_login? && authorized_password?
    end

    def invalid?
      !valid?
    end

    private

    def secret
      @secret
    end

    def decrypt attribute
      if attribute.present? && secret.present?
        cipher = Auther::Cipher.new secret
        cipher.decrypt attribute
      end
    end

    def authorized? attribute, secure_attribute, error_name
      if attribute == decrypt(secure_attribute)
        true
      else
        errors.add error_name, "is invalid"
        false
      end
    end

    def authorized_login?
      authorized? login, encrypted_login, "login"
    end

    def authorized_password?
      authorized? password, encrypted_password, "password"
    end
  end
end
