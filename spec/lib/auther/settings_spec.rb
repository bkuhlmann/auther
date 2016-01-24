# frozen_string_literal: true

require "spec_helper"

RSpec.describe Auther::Settings do
  let :settings do
    {
      secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
      accounts: [
        {
          name: "test-1",
          login: "test-1@test.com",
          secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
          secure_login: "M0dGeWRoc3pLbmVidy9QY1lpczh5bm5KaFpRZ0VYMFBYMkpLKzFzTHdWdz0tLXh0VytLcHBvNDZGeVl0bVhhRXVXREE9PQ==--82e827cf8148d6507052eb14d8c71ee33ceabbff",
          password: "nevermore",
          secure_password: "UXM1akhTSjhUVFQ1Um1yZFBNSFNid09WejlmY1F4eU1oREMzamdCK05nTT0tLW4vN20xTzZmVi9rNXNFSnJXWTlzekE9PQ==--6a8a0efcfb988c69749b4ef9375f6c10b0dce6fa",
          paths: ["/admin"]
        },
        {
          name: "test-2",
          login: "test-2@test.com",
          secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
          secure_login: "ZDBwN0RyK3lJcEQ5VzZzMFpqUm82OUtUaThKWjVoMXVxTk1uTEdKNzVObz0tLVQvQ3VVZmtneTZoMldSYlcwWHpnN0E9PQ==--b78628e0ccb707f30764b18ca71de49aebd91b07",
          password: "evergreen",
          secure_password: "cDdVcDlOZ01KQ05pdXVzRWRoRUtnQVFhem9vWFdYdEsweWtRUFlkUkU0UT0tLWRTVnFQdUdvVlRWcGtybUFSc0FJMXc9PQ==--2baa181591ad7e171a6cb87b98ca4517486f10d5",
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
          secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
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
