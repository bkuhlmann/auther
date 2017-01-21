# frozen_string_literal: true

require "spec_helper"

RSpec.describe Auther::Authenticator do
  let(:secret) { "\xE4]c\xE8ȿOh%\xB5\xF4\xD5\u0012\xB0\u000F\xF0\xF8Í\xFCKZ\u0000R~9\u0019\xE3\u0011xk\xB2" }
  let(:encrypted_login) { "ZzNEY0gxWVdEQzdBTmppWnFNbGwvQT09LS1ZSWdwUFU5VklyVWY1cjJNS0FBWUJ3PT0=--4498bdb1461305d9ef218f7886bd903d00c44ce0" }
  let(:encrypted_password) { "OXRlRkpMTEsxbGJuQnVUNHRMSFgvRVhLREFJeW9hNzRzNFBId2kzeSs4QT0tLWJYakVRd0pXR1JQeXFyL0NVSk1XbWc9PQ==--d5bc91dcdb9117a2edbdba7e3cf8b4f3b53d09f5" }
  let(:account_model) { Auther::Account.new name: "test", encrypted_login: encrypted_login, encrypted_password: encrypted_password }
  let(:account_presenter) { Auther::Presenter::Account.new name: "test", login: "admin", password: "nevermore" }
  let(:logger) { instance_spy Auther::NullLogger }
  subject { Auther::Authenticator.new secret, account_model, account_presenter, logger: logger }

  describe "#authenticated?" do
    it "answers true when model/presenter are valid, names match, logins match, and passwords match" do
      expect(subject.authenticated?).to be(true)
    end

    it "answers false when model is invalid" do
      allow(account_model).to receive(:valid?).and_return(false)
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when presenter is invalid" do
      allow(account_presenter).to receive(:valid?).and_return(false)
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when model name is invalid" do
      account_model.name = "bogus"
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when model encrypted login is invalid" do
      account_model.encrypted_login = "bogus"
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when model encrypted password is invalid" do
      account_model.encrypted_password = "bogus"
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when presenter name is invalid" do
      account_presenter.name = "bogus"
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when presenter login is invalid" do
      account_presenter.login = "bogus"
      expect(subject.authenticated?).to be(false)
    end

    it "answers false when presenter password is invalid" do
      account_presenter.password = "bogus"
      expect(subject.authenticated?).to be(false)
    end

    context "when encrypted value can't be decrypted" do
      let(:encrypted_login) { "bogus" }
      let(:message) { %([auther]: Authentication failed! Invalid credential(s) for "#{account_model.name}" account.) }

      it "logs authentication failure" do
        subject.authenticated?
        expect(logger).to have_received(:info).with(message).once
      end
    end
  end
end
