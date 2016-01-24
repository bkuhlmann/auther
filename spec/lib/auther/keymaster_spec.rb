# frozen_string_literal: true

require "spec_helper"

RSpec.describe Auther::Keymaster do
  describe ".get_account_name" do
    subject { Auther::Keymaster }

    let(:session) do
      {
        "auther_test_login" => "testy",
        "auther_test_password" => "tester"
      }
    end

    it "answers account name when found in session" do
      expect(subject.get_account_name(session)).to eq("test")
    end

    it "answers blank string for empty session" do
      expect(subject.get_account_name).to eq("")
    end
  end

  describe ".redirect_url_key" do
    subject { Auther::Keymaster }

    it "answers redirect url key with default delimiter" do
      expect(subject.redirect_url_key).to eq("auther_redirect_url")
    end

    it "answers redirect url key with custom delimiter" do
      expect(subject.redirect_url_key(delimiter: "-")).to eq("auther-redirect-url")
    end
  end

  describe "#login_key" do
    subject { Auther::Keymaster.new "test" }

    it "answers a login key with account name" do
      expect(subject.login_key).to eq("auther_test_login")
    end

    it "answers a login key without account name" do
      subject = Auther::Keymaster.new
      expect(subject.login_key).to eq("auther_login")
    end
  end

  describe "#password_key" do
    subject { Auther::Keymaster.new "test" }

    it "answers a password key with account name" do
      expect(subject.password_key).to eq("auther_test_password")
    end

    it "answers a password key without account name" do
      subject = Auther::Keymaster.new
      expect(subject.password_key).to eq("auther_password")
    end
  end
end
