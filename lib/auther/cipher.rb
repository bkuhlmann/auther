# frozen_string_literal: true

module Auther
  # Manages encryption/decryption.
  class Cipher
    BYTE_DIVISOR = 2

    def self.generate login, password
      secret = SecureRandom.hex key_length / BYTE_DIVISOR
      cipher = new secret

      {secret:, login: cipher.encrypt(login), password: cipher.encrypt(password)}
    end

    def self.key_length
      ActiveSupport::MessageEncryptor.key_len
    end

    def initialize secret
      @encryptor = ActiveSupport::MessageEncryptor.new secret
    end

    def encrypt data
      encryptor.encrypt_and_sign data
    end

    def decrypt data
      encryptor.decrypt_and_verify data
    end

    private

    attr_reader :encryptor
  end
end
