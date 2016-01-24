# frozen_string_literal: true

module Auther
  # Manages encryption/decryption.
  class Cipher
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
