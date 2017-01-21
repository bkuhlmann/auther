# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe Auther::Gatekeeper, :credentials do
  include Rack::Test::Methods

  let(:env) { {"rack.session" => {}, "PATH_INFO" => "/"} }
  let(:app) { ->(env) { [200, env, ["OK"]] } }
  let(:auth_url) { "/login" }

  describe "#initialize" do
    subject { Auther::Gatekeeper.new app, secret: secret, accounts: [] }

    it "sets application" do
      expect(subject.application).to eq(app)
    end

    it "sets settings" do
      expect(subject.settings).to be_a(Auther::Settings)
    end
  end

  describe "#call" do
    describe "single account" do
      subject do
        Auther::Gatekeeper.new app, accounts: [
          {
            name: "admin",
            encrypted_login: encrypted_login,
            encrypted_password: encrypted_password,
            paths: [
              "/admin",
              "/member",
              "/trailing_slash/"
            ],
            authorized_url: "/admin/dashboard"
          }
        ],
                                    secret: secret,
                                    auth_url: auth_url
      end

      context "non-blacklisted path" do
        context "unauthenticated account" do
          it "passes authorization with random path" do
            env["PATH_INFO"] = "/some/random/path"

            result = subject.call env
            expect(result[1].key?("Location")).to be(false)
          end

          it "adds request path as request url to session" do
            path = "/admin"
            env["PATH_INFO"] = path
            subject.call env

            expect(env["rack.session"]["auther_redirect_url"]).to eq(path)
          end

          # NOTE: See Gatekeeper settings where trailing slash path is defined for this test.
          it "adds request (trailing slash) path as request url to session" do
            path = "/trailing_slash"
            env["PATH_INFO"] = path
            subject.call env

            expect(env["rack.session"]["auther_redirect_url"]).to eq(path)
          end
        end

        context "authenticated account" do
          it "passes authorization with random path" do
            env["rack.session"]["auther_public_login"] = encrypted_login
            env["rack.session"]["auther_public_password"] = encrypted_password
            env["PATH_INFO"] = "/some/random/path"

            result = subject.call env
            expect(result[1].key?("Location")).to be(false)
          end
        end
      end

      context "blacklisted path" do
        it "fails authorization with unknown account" do
          env["PATH_INFO"] = "/admin"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with encrypted, invalid login" do
          env["rack.session"]["auther_public_login"] = "bogus"
          env["rack.session"]["auther_public_password"] = encrypted_password
          env["PATH_INFO"] = "/admin"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with encrypted, invalid password" do
          env["rack.session"]["auther_public_login"] = encrypted_login
          env["rack.session"]["auther_public_password"] = "bogus"
          env["PATH_INFO"] = "/admin"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with unencrypted login" do
          env["rack.session"]["auther_public_login"] = "cracker"
          env["rack.session"]["auther_public_password"] = encrypted_password
          env["PATH_INFO"] = "/admin"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with unencrypted password" do
          env["rack.session"]["auther_public_login"] = encrypted_login
          env["rack.session"]["auther_public_password"] = "opensesame"
          env["PATH_INFO"] = "/admin"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with nested path" do
          env["PATH_INFO"] = "/admin/nested/path"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end
      end
    end

    describe "multiple accounts" do
      let(:member_login) { cipher.encrypt "member" }
      let(:member_password) { cipher.encrypt "password" }
      let(:admin_login) { cipher.encrypt "admin" }
      let(:admin_password) { cipher.encrypt "for-your-eyes-only" }

      subject do
        Auther::Gatekeeper.new app, accounts: [
          {
            name: "member",
            encrypted_login: member_login,
            encrypted_password: member_password,
            paths: [
              "/member"
            ]
          },
          {
            name: "admin",
            encrypted_login: admin_login,
            encrypted_password: admin_password,
            paths: [
              "/admin",
              "/member"
            ]
          }
        ],
                                    secret: secret,
                                    auth_url: auth_url
      end

      context "non-blacklisted path" do
        it "passes authorization with authenticated account" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/public"

          result = subject.call env
          expect(result[1].key?("Location")).to be(false)
        end

        it "logs requested path, account found, authentication passed, and authorization passed." do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/member"

          path_message = %([auther]: Requested path "/member" found in blacklisted paths: ["/member", "/admin"].)
          account_message = "[auther]: Account found."
          authentication_message = %([auther]: Authentication passed. Account: "member".)
          authorization_message = %([auther]: Authorization passed. Account: "member". Blacklist: ["/member", "/admin"]. Request Path: "/member".)

          expect(subject.logger).to receive(:info).with(path_message).once
          expect(subject.logger).to receive(:info).with(account_message).once
          expect(subject.logger).to receive(:info).with(authentication_message).once
          expect(subject.logger).to receive(:info).with(authorization_message).once

          subject.call env
        end
      end

      context "blacklisted path" do
        it "fails authorization with unauthenticated account" do
          env["PATH_INFO"] = "/member"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with authenticated account" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"

          result = subject.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "logs requested path and account unknown" do
          env["PATH_INFO"] = "/member"

          path_message = %([auther]: Requested path "/member" found in blacklisted paths: ["/member", "/admin"].)
          account_message = "[auther]: Account unknown."

          expect(subject.logger).to receive(:info).with(path_message).once
          expect(subject.logger).to receive(:info).with(account_message).once

          subject.call env
        end

        it "logs requested path, account found, and authentication failed." do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = "bogus"
          env["PATH_INFO"] = "/member"

          path_message = %([auther]: Requested path "/member" found in blacklisted paths: ["/member", "/admin"].)
          account_message = "[auther]: Account found."
          authentication_message = %([auther]: Authentication failed! Invalid credential(s) for "member" account.)

          expect(subject.logger).to receive(:info).with(path_message).once
          expect(subject.logger).to receive(:info).with(account_message).once
          expect(subject.logger).to receive(:info).with(authentication_message).once

          subject.call env
        end

        it "logs requested path, account found, authentication passed, and authorization failed" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"

          path_message = %([auther]: Requested path "/admin" found in blacklisted paths: ["/member", "/admin"].)
          account_message = "[auther]: Account found."
          authentication_message = %([auther]: Authentication passed. Account: "member".)
          authorization_message = %([auther]: Authorization failed! Account: "member". Blacklist: ["/member", "/admin"]. Request Path: "/admin".)

          expect(subject.logger).to receive(:info).with(path_message).once
          expect(subject.logger).to receive(:info).with(account_message).once
          expect(subject.logger).to receive(:info).with(authentication_message).once
          expect(subject.logger).to receive(:info).with(authorization_message).once

          subject.call env
        end
      end
    end
  end
end
