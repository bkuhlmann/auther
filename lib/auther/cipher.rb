module Auther
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

    def encryptor
      @encryptor
    end
  end
end
