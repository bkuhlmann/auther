# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Authenticator, :credentials do
  subject :authenticator do
    described_class.new secret, account_model, account_presenter, logger: logger
  end

  let :account_model do
    Auther::Account[
      name: "test",
      encrypted_login: encrypted_login,
      encrypted_password: encrypted_password
    ]
  end

  let :account_presenter do
    Auther::Presenter::Account.new name: "test", login: "tester", password: "nevermore"
  end

  let(:logger) { instance_spy Auther::NullLogger }

  describe "#authenticated?" do
    it "answers true when model/presenter are valid and names, logins, and passwords match" do
      expect(authenticator.authenticated?).to be(true)
    end

    it "answers false when model is invalid" do
      allow(account_model).to receive(:valid?).and_return(false)
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when presenter is invalid" do
      allow(account_presenter).to receive(:valid?).and_return(false)
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when model name is invalid" do
      account_model.name = "bogus"
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when model encrypted login is invalid" do
      account_model.encrypted_login = "bogus"
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when model encrypted password is invalid" do
      account_model.encrypted_password = "bogus"
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when presenter name is invalid" do
      account_presenter.name = "bogus"
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when presenter login is invalid" do
      account_presenter.login = "bogus"
      expect(authenticator.authenticated?).to be(false)
    end

    it "answers false when presenter password is invalid" do
      account_presenter.password = "bogus"
      expect(authenticator.authenticated?).to be(false)
    end

    context "when encrypted value can't be decrypted" do
      let(:encrypted_login) { "bogus" }
      let :message do
        %([auther]: Authentication failed! ) +
          %(Invalid credential(s) for "#{account_model.name}" account.)
      end

      it "logs authentication failure" do
        authenticator.authenticated?
        expect(logger).to have_received(:info).with(message).once
      end
    end
  end
end
