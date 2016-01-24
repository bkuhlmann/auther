# frozen_string_literal: true

require "spec_helper"

RSpec.describe Auther::Authenticator do
  let(:secret) { "8F^Ve2oYhaMYVvaWPAj}7Ks}U6FeJ*oNYjcXP,6AmdXhsNU?Xeu7jb)8:JH4" }
  let(:encrypted_login) { "dGJrVXUvcy91djE1eThBTDVLbEhybGtTS2dzYy85VmZXREZTVUVPVU9Sdz0tLURjWTRpaTlYOUdjU2VpUG81Y3FhNWc9PQ==--88916f89ff39860b4ef8c12ae2ef7af6a6966cd4" }
  let(:encrypted_password) { "RlA5cURFall4eEp0UFNLRzA1NVhtMkIyUnNqWlVqcSsvd2VGeURwbXJEST0tLXlPZ0Z1aElaS2ZYT003Ny9Pc1BBb3c9PQ==--510f42afd06ba015202a90b883451ae4b0dd23c2" }
  let(:account_model) { Auther::Account.new name: "test", encrypted_login: encrypted_login, encrypted_password: encrypted_password }
  let(:account_presenter) { Auther::Presenter::Account.new name: "test", login: "test@test.com", password: "nevermore" }
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
