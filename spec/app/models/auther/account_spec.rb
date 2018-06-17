# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Account, :credentials do
  subject do
    Auther::Account.new name: "test",
                        encrypted_login: encrypted_login,
                        encrypted_password: encrypted_password
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
      subject.paths = nil

      expect(subject.invalid?).to be(true)
      expect(subject.errors.full_messages).to include("Paths must be an array")
    end
  end
end
