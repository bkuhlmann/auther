# frozen_string_literal: true

require "rails_helper"
require "securerandom"

RSpec.describe Auther::Cipher do
  let(:secret) { SecureRandom.random_bytes 32 }
  let(:encryptor) { ActiveSupport::MessageEncryptor.new secret }
  let(:encrypted_data) { encryptor.encrypt_and_sign "password" }
  let(:decrypted_data) { "password" }
  subject { Auther::Cipher.new secret }

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
