# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Keymaster do
  describe ".get_account_name" do
    subject(:keymaster) { described_class }

    let(:session) do
      {
        "auther_test_login" => "testy",
        "auther_test_password" => "tester"
      }
    end

    it "answers account name when found in session" do
      expect(keymaster.get_account_name(session)).to eq("test")
    end

    it "answers blank string for empty session" do
      expect(keymaster.get_account_name).to eq("")
    end
  end

  describe ".redirect_url_key" do
    subject(:keymaster) { described_class }

    it "answers redirect url key with default delimiter" do
      expect(keymaster.redirect_url_key).to eq("auther_redirect_url")
    end

    it "answers redirect url key with custom delimiter" do
      expect(keymaster.redirect_url_key(delimiter: "-")).to eq("auther-redirect-url")
    end
  end

  describe "#login_key" do
    subject(:keymaster) { described_class.new "test" }

    it "answers a login key with account name" do
      expect(keymaster.login_key).to eq("auther_test_login")
    end

    it "answers a login key without account name" do
      keymaster = described_class.new
      expect(keymaster.login_key).to eq("auther_login")
    end
  end

  describe "#password_key" do
    subject(:keymaster) { described_class.new "test" }

    it "answers a password key with account name" do
      expect(keymaster.password_key).to eq("auther_test_password")
    end

    it "answers a password key without account name" do
      keymaster = described_class.new
      expect(keymaster.password_key).to eq("auther_password")
    end
  end
end
