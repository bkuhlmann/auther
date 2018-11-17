# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe Auther::Gatekeeper, :credentials do
  include Rack::Test::Methods

  let(:env) { {"rack.session" => {}, "PATH_INFO" => "/"} }
  let(:app) { ->(env) { [200, env, ["OK"]] } }
  let(:auth_url) { "/login" }
  let(:logger) { instance_spy Logger }

  describe "#initialize" do
    subject(:gatekeeper) { described_class.new app, secret: secret, accounts: [] }

    it "sets application" do
      expect(gatekeeper.application).to eq(app)
    end

    it "sets settings" do
      expect(gatekeeper.settings).to be_a(Auther::Settings)
    end
  end

  describe "#call" do
    describe "single account" do
      subject(:gatekeeper) do
        described_class.new(
          app,
          accounts: [
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
        )
      end

      context "non-excluded path" do
        context "unauthenticated account" do
          it "passes authorization with random path" do
            env["PATH_INFO"] = "/some/random/path"

            result = gatekeeper.call env
            expect(result[1].key?("Location")).to be(false)
          end

          it "adds request path as request url to session" do
            path = "/admin"
            env["PATH_INFO"] = path
            gatekeeper.call env

            expect(env["rack.session"]["auther_redirect_url"]).to eq(path)
          end

          # NOTE: See Gatekeeper settings where trailing slash path is defined for this test.
          it "adds request (trailing slash) path as request url to session" do
            path = "/trailing_slash"
            env["PATH_INFO"] = path
            gatekeeper.call env

            expect(env["rack.session"]["auther_redirect_url"]).to eq(path)
          end
        end

        context "authenticated account" do
          it "passes authorization with random path" do
            env["rack.session"]["auther_public_login"] = encrypted_login
            env["rack.session"]["auther_public_password"] = encrypted_password
            env["PATH_INFO"] = "/some/random/path"

            result = gatekeeper.call env
            expect(result[1].key?("Location")).to be(false)
          end
        end
      end

      context "excluded path" do
        it "fails authorization with unknown account" do
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with encrypted, invalid login" do
          env["rack.session"]["auther_public_login"] = "bogus"
          env["rack.session"]["auther_public_password"] = encrypted_password
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with encrypted, invalid password" do
          env["rack.session"]["auther_public_login"] = encrypted_login
          env["rack.session"]["auther_public_password"] = "bogus"
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with unencrypted login" do
          env["rack.session"]["auther_public_login"] = "cracker"
          env["rack.session"]["auther_public_password"] = encrypted_password
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with unencrypted password" do
          env["rack.session"]["auther_public_login"] = encrypted_login
          env["rack.session"]["auther_public_password"] = "opensesame"
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with nested path" do
          env["PATH_INFO"] = "/admin/nested/path"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(auth_url)
        end
      end
    end

    describe "multiple accounts" do
      subject(:gatekeeper) do
        described_class.new(
          app,
          accounts: [
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
          auth_url: auth_url,
          logger: logger
        )
      end

      let(:member_login) { cipher.encrypt "member" }
      let(:member_password) { cipher.encrypt "password" }
      let(:admin_login) { cipher.encrypt "admin" }
      let(:admin_password) { cipher.encrypt "for-your-eyes-only" }

      context "non-excluded path" do
        it "passes authorization with authenticated account" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/public"

          result = gatekeeper.call env

          expect(result[1].key?("Location")).to be(false)
        end

        it "logs requested path, account found, authentication passed, and authorization passed.", :aggregate_failures do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/member"

          path_message = %([auther]: Requested path "/member" found in excluded paths: ["/member", "/admin"].)
          account_message = "[auther]: Account found."
          authentication_message = %([auther]: Authentication passed. Account: "member".)
          authorization_message = %([auther]: Authorization passed. Account: "member". Excludes: ["/member", "/admin"]. Request Path: "/member".)

          gatekeeper.call env

          expect(logger).to have_received(:info).with(path_message).once
          expect(logger).to have_received(:info).with(account_message).once
          expect(logger).to have_received(:info).with(authentication_message).once
          expect(logger).to have_received(:info).with(authorization_message).once
        end
      end

      context "excluded path" do
        it "fails authorization with unauthenticated account" do
          env["PATH_INFO"] = "/member"
          result = gatekeeper.call env

          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "fails authorization with authenticated account" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env

          expect(result[1]["Location"]).to eq(auth_url)
        end

        it "logs requested path and account unknown", :aggregate_failures do
          env["PATH_INFO"] = "/member"

          path_message = %([auther]: Requested path "/member" found in excluded paths: ["/member", "/admin"].)
          account_message = "[auther]: Account unknown."

          gatekeeper.call env

          expect(logger).to have_received(:info).with(path_message).once
          expect(logger).to have_received(:info).with(account_message).once
        end

        it "logs requested path, account found, and authentication failed.", :aggregate_failures do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = "bogus"
          env["PATH_INFO"] = "/member"

          path_message = %([auther]: Requested path "/member" found in excluded paths: ["/member", "/admin"].)
          account_message = "[auther]: Account found."
          authentication_message = %([auther]: Authentication failed! Invalid credential(s) for "member" account.)

          gatekeeper.call env

          expect(logger).to have_received(:info).with(path_message).once
          expect(logger).to have_received(:info).with(account_message).once
          expect(logger).to have_received(:info).with(authentication_message).once
        end

        it "logs requested path, account found, authentication passed, and authorization failed", :aggregate_failures do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"

          path_message = %([auther]: Requested path "/admin" found in excluded paths: ["/member", "/admin"].)
          account_message = "[auther]: Account found."
          authentication_message = %([auther]: Authentication passed. Account: "member".)
          authorization_message = %([auther]: Authorization failed! Account: "member". Excludes: ["/member", "/admin"]. Request Path: "/admin".)

          gatekeeper.call env

          expect(logger).to have_received(:info).with(path_message).once
          expect(logger).to have_received(:info).with(account_message).once
          expect(logger).to have_received(:info).with(authentication_message).once
          expect(logger).to have_received(:info).with(authorization_message).once
        end
      end
    end
  end
end
# rubocop:enable Metrics/LineLength
