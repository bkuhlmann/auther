# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Account, :credentials do
  subject :account do
    described_class.new name: "test",
                        encrypted_login: encrypted_login,
                        encrypted_password: encrypted_password
  end

  describe "#name" do
    it "answers name" do
      expect(account.name).to eq("test")
    end
  end

  describe "#encrypted_login" do
    it "answers encrypted login" do
      expect(account.encrypted_login).to eq(encrypted_login)
    end
  end

  describe "#encrypted_password" do
    it "answers encrypted password" do
      expect(account.encrypted_password).to eq(encrypted_password)
    end
  end

  describe "#paths" do
    it "answers default paths" do
      expect(account.paths).to eq([])
    end

    it "answers custom paths" do
      account = described_class.new paths: %w[a b c]
      expect(account.paths).to contain_exactly("a", "b", "c")
    end
  end

  describe "#authorized_url" do
    it "answers custom URL" do
      account = described_class.new authorized_url: "/test"
      expect(account.authorized_url).to eq("/test")
    end
  end

  describe "#deauthorized_url" do
    it "answers custom URL" do
      account = described_class.new deauthorized_url: "/test"
      expect(account.deauthorized_url).to eq("/test")
    end
  end

  describe "#valid?" do
    it "answers true when name, encrypted login, and encrypted password are present" do
      expect(account.valid?).to be(true)
    end

    it "answers true paths is an array" do
      account.paths = []
      expect(account.valid?).to be(true)
    end
  end

  describe "#invalid?" do
    it "answers true when name is not present" do
      account.name = nil
      expect(account.invalid?).to be(true)
    end

    it "answers true when encrypted login is not present" do
      account.encrypted_login = nil
      expect(account.invalid?).to be(true)
    end

    it "answers true when encrypted password is not present" do
      account.encrypted_password = nil
      expect(account.invalid?).to be(true)
    end

    it "answers true when paths is not an array" do
      account.paths = "bogus"
      expect(account.invalid?).to be(true)
    end

    it "answers error when paths is not an array" do
      account.paths = "bogus"
      account.invalid?

      expect(account.errors.full_messages).to include("Paths must be an array")
    end
  end
end
