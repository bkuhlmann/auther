# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Settings, :credentials do
  let :settings do
    {
      secret: secret,
      accounts: [
        {
          name: "test-1",
          secret: secret,
          login: "test-1@test.com",
          secure_login: cipher.encrypt("test-1@test.com"),
          password: "nevermore",
          secure_password: cipher.encrypt("nevermore"),
          paths: ["/admin"]
        },
        {
          name: "test-2",
          secret: secret,
          login: "test-2@test.com",
          secure_login: cipher.encrypt("test-2@test.com"),
          password: "evergreen",
          secure_password: cipher.encrypt("evergreen"),
          paths: ["/member"]
        }
      ]
    }
  end

  subject { Auther::Settings.new settings }

  describe "#initialize" do
    context "defaults" do
      it "sets title" do
        expect(subject.title).to eq("Authorization")
      end

      it "sets label" do
        expect(subject.title).to eq("Authorization")
      end

      it "sets auth URL" do
        expect(subject.auth_url).to eq("/login")
      end

      it "sets logger" do
        expect(subject.logger).to be_a(Auther::NullLogger)
      end
    end

    context "custom" do
      let :settings do
        {
          title: "Test",
          label: "Test",
          secret: secret,
          accounts: [],
          auth_url: "/test",
          logger: Logger.new(STDOUT)
        }
      end

      subject { Auther::Settings.new settings }

      it "sets title" do
        expect(subject.title).to eq("Test")
      end

      it "sets label" do
        expect(subject.title).to eq("Test")
      end

      it "sets auth URL" do
        expect(subject.auth_url).to eq("/test")
      end

      it "sets logger" do
        expect(subject.logger).to be_a(Logger)
      end
    end
  end

  describe "#find_account" do
    it "answers account for given name" do
      name = "test-2"
      account = subject.find_account name

      expect(account.fetch(:name)).to eq(name)
    end

    it "answers nil for missing account" do
      name = "bogus"
      account = subject.find_account name

      expect(account).to eq(nil)
    end
  end
end
