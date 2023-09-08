# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Presenter::Account do
  subject :account do
    described_class.new name: "test", login: "test@test.com", password: "nevermore"
  end

  describe "#valid?" do
    it "answers true when name, login, and password are present" do
      expect(account.valid?).to be(true)
    end
  end

  describe "#invalid?" do
    it "answers true when name is not present" do
      account.name = nil
      expect(account.invalid?).to be(true)
    end

    it "answers true when login is not present" do
      account.login = nil
      expect(account.invalid?).to be(true)
    end

    it "answers true when password is not present" do
      account.password = nil
      expect(account.invalid?).to be(true)
    end
  end

  describe "#error?" do
    before { account.valid? }

    context "when attributes exist" do
      it "answers false" do
        expect(account.error?(:login)).to be(false)
      end
    end

    context "when an attribute is missing" do
      subject(:account) { described_class.new name: "test", login: "test@test.com" }

      it "answers true" do
        expect(account.error?(:password)).to be(true)
      end
    end
  end

  describe "#error_message" do
    before { account.valid? }

    context "when errors exist" do
      subject(:account) { described_class.new }

      it "answers full error message" do
        expect(account.error_message(:password)).to eq("Password can't be blank")
      end
    end

    context "when errors don't exist" do
      it "answers an empty string" do
        expect(account.error_message(:login)).to eq("")
      end
    end
  end
end
