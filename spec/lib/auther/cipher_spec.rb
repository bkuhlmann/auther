# frozen_string_literal: true

require "rails_helper"
require "securerandom"

RSpec.describe Auther::Cipher do
  let(:secret) { SecureRandom.random_bytes ActiveSupport::MessageEncryptor.key_len }
  let(:encryptor) { ActiveSupport::MessageEncryptor.new secret }
  let(:encrypted_data) { encryptor.encrypt_and_sign "password" }
  let(:decrypted_data) { "password" }
  subject { Auther::Cipher.new secret }

  describe ".generate" do
    it "answers credentials" do
      expect(described_class.generate("test", "password")).to match(
        secret: match(/\A[0-9a-f]{#{described_class.key_length}}\Z/),
        login: match(%r(\A[0-9a-zA-Z\=\-\+\/]{110}\Z)),
        password: match(%r(\A[0-9a-zA-Z\=\-\+\/]{138}\Z))
      )
    end
  end

  describe ".key_length" do
    it "answers key length" do
      expect(described_class.key_length).to eq(32)
    end
  end

  describe "#encrypt" do
    it "encrypts data" do
      expect(subject.encrypt(decrypted_data)).to match(/[a-zA-Z0-9]{94}\=\=\-\-[a-z0-9]{40}/)
    end
  end

  describe "#decrypt" do
    it "decrypts data" do
      expect(subject.decrypt(encrypted_data)).to eq(decrypted_data)
    end
  end
end
