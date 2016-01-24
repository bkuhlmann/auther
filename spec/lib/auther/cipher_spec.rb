# frozen_string_literal: true

require "spec_helper"

RSpec.describe Auther::Cipher do
  let(:secret) { "8F^Ve2oYhaMYVvaWPAj}7Ks}U6FeJ*oNYjcXP,6AmdXhsNU?Xeu7jb)8:JH4" }
  let(:encrypted_data) { "WmxBdlhvQ1B6S01ZNTl5NFk1cG1OdTNvaWhvenVVNWxNb2k3UThOVzdFaz0tLStUV1lmMTBEUG1VbFE1YlhnaGJocXc9PQ==--1dc715907f07a7687b054952078d8f956372fe86" }
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
