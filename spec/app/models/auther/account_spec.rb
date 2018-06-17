# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Account, :credentials do
  subject do
    described_class.new name: "test",
                        encrypted_login: encrypted_login,
                        encrypted_password: encrypted_password
  end

  describe "#name" do
    it "answers name" do
      expect(subject.name).to eq("test")
    end
  end

  describe "#encrypted_login" do
    it "answers encrypted login" do
      expect(subject.encrypted_login).to eq(encrypted_login)
    end
  end

  describe "#encrypted_password" do
    it "answers encrypted password" do
      expect(subject.encrypted_password).to eq(encrypted_password)
    end
  end

  describe "#paths" do
    it "answers default paths" do
      expect(subject.paths).to eq([])
    end

    it "answers custom paths" do
      subject = described_class.new paths: %w[a b c]
      expect(subject.paths).to contain_exactly("a", "b", "c")
    end
  end

  describe "#authorized_url" do
    it "answers custom URL" do
      subject = described_class.new authorized_url: "/test"
      expect(subject.authorized_url).to eq("/test")
    end
  end

  describe "#deauthorized_url" do
    it "answers custom URL" do
      subject = described_class.new deauthorized_url: "/test"
      expect(subject.deauthorized_url).to eq("/test")
    end
  end

  describe "#valid?" do
    it "answers true when name, encrypted login, and encrypted password are present" do
      expect(subject.valid?).to be(true)
    end

    it "answers true paths is an array" do
      subject.paths = []
      expect(subject.valid?).to be(true)
    end
  end

  describe "#invalid?" do
    it "answers true when name is not present" do
      subject.name = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when encrypted login is not present" do
      subject.encrypted_login = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when encrypted password is not present" do
      subject.encrypted_password = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when paths is not an array" do
      subject.paths = "bogus"

      expect(subject.invalid?).to be(true)
      expect(subject.errors.full_messages).to include("Paths must be an array")
    end
  end
end
