module Auther
  class Account
    include ActiveModel::Validations

    attr_accessor :name, :login, :secure_login, :password, :secure_password, :paths

    validates :name, presence: true
    validates :paths, presence: {unless: lambda { |account| account.paths.is_a? Array }, message: "must be an array"}

    def initialize name: nil, login: nil, secure_login: nil, password: nil, secure_password: nil, paths: [], secret: nil
      @name = name
      @login = login
      @secure_login = secure_login
      @password = password
      @secure_password = secure_password
      @paths = paths
      @secret = secret
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
