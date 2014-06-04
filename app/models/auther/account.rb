require "active_model"

module Auther
  class Account
    include ActiveModel::Validations

    attr_accessor :name, :login, :secure_login, :password, :secure_password, :paths, :success_url

    validates :name, presence: true
    validates :paths, presence: {unless: lambda { |account| account.paths.is_a? Array }, message: "must be an array"}

    def initialize options = {}
      @name = options.fetch :name, nil
      @login = options.fetch :login, nil
      @secure_login = options.fetch :secure_login, nil
      @password = options.fetch :password, nil
      @secure_password = options.fetch :secure_password, nil
      @paths = options.fetch :paths, []
      @secret = options.fetch :secret, nil
      @success_url = options.fetch :success_url, nil
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
      authorized? login, secure_login, "login"
    end

    def authorized_password?
      authorized? password, secure_password, "password"
    end
  end
end
