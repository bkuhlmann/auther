# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Settings, :credentials do
  subject(:settings) { described_class.new data }

  let :data do
    {
      secret:,
      accounts: [
        {
          name: "test-1",
          secret:,
          login: "test-1@test.com",
          secure_login: cipher.encrypt("test-1@test.com"),
          password: "nevermore",
          secure_password: cipher.encrypt("nevermore"),
          paths: ["/admin"]
        },
        {
          name: "test-2",
          secret:,
          login: "test-2@test.com",
          secure_login: cipher.encrypt("test-2@test.com"),
          password: "evergreen",
          secure_password: cipher.encrypt("evergreen"),
          paths: ["/member"]
        }
      ]
    }
  end

  describe "#initialize" do
    context "with defaults" do
      it "sets title" do
        expect(settings.title).to eq("Authorization")
      end

      it "sets label" do
        expect(settings.label).to eq("Authorization")
      end

      it "sets auth URL" do
        expect(settings.url).to eq("/login")
      end

      it "sets logger" do
        expect(settings.logger).to be_a(Auther::NullLogger)
      end
    end

    context "with customization" do
      subject(:settings) { described_class.new data }

      let :data do
        {
          title: "Test",
          label: "Test",
          secret:,
          accounts: [],
          url: "/test",
          logger: Logger.new(STDOUT)
        }
      end

      it "sets title" do
        expect(settings.title).to eq("Test")
      end

      it "sets label" do
        expect(settings.label).to eq("Test")
      end

      it "sets auth URL" do
        expect(settings.url).to eq("/test")
      end

      it "sets logger" do
        expect(settings.logger).to be_a(Logger)
      end
    end
  end

  describe "#find_account" do
    it "answers account for given name" do
      name = "test-2"
      account = settings.find_account name

      expect(account.fetch(:name)).to eq(name)
    end

    it "answers nil for missing account" do
      name = "bogus"
      account = settings.find_account name

      expect(account).to be_nil
    end
  end
end
