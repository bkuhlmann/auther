# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Cipher do
  let(:secret) { "\xE4]c\xE8\xC8\xBFOh%\xB5\xF4\xD5\x12\xB0\x0F\xF0\xF8\xC3\x8D\xFCKZ\x00R~9\x19\xE3\x11xk\xB2" }
  let(:encrypted_data) { "ZDVGRDhlc09HL1lLcExGUVVldnBuL2cwcGtWMTU0MkNLWlBMK3JDdlRiUT0tLU1xQkR4ZzhaN1BQZ25XVFYxQldZWUE9PQ==--07a95f72a7e1e0138ef782ec13d6b2631450da1b" }
  let(:decrypted_data) { "password" }
  subject { Auther::Cipher.new secret }

  describe "#encrypt" do
    it "encrypts data" do
      # Tested by ActiveSupport::MessageEncryptor
    end
  end

  describe "#decrypt" do
    it "decrypts data" do
      expect(subject.decrypt(encrypted_data)).to eq(decrypted_data)
    end
  end
end
