# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe Auther::Gatekeeper, :credentials do
  include Rack::Test::Methods

  let(:env) { {"rack.session" => {}, "PATH_INFO" => "/"} }
  let(:app) { ->(env) { [200, env, ["OK"]] } }
  let(:url) { "/login" }
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

  # rubocop:disable RSpec/NestedGroups
  describe "#call" do
    context "with single account" do
      subject :gatekeeper do
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
          url: url
        )
      end

      context "with non-excluded path" do
        context "with unauthenticated account" do
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

        context "with authenticated account" do
          it "passes authorization with random path" do
            env["rack.session"]["auther_public_login"] = encrypted_login
            env["rack.session"]["auther_public_password"] = encrypted_password
            env["PATH_INFO"] = "/some/random/path"

            result = gatekeeper.call env
            expect(result[1].key?("Location")).to be(false)
          end
        end
      end

      context "with excluded path" do
        it "fails authorization with unknown account" do
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(url)
        end

        it "fails authorization with encrypted, invalid login" do
          env["rack.session"]["auther_public_login"] = "bogus"
          env["rack.session"]["auther_public_password"] = encrypted_password
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(url)
        end

        it "fails authorization with encrypted, invalid password" do
          env["rack.session"]["auther_public_login"] = encrypted_login
          env["rack.session"]["auther_public_password"] = "bogus"
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(url)
        end

        it "fails authorization with unencrypted login" do
          env["rack.session"]["auther_public_login"] = "cracker"
          env["rack.session"]["auther_public_password"] = encrypted_password
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(url)
        end

        it "fails authorization with unencrypted password" do
          env["rack.session"]["auther_public_login"] = encrypted_login
          env["rack.session"]["auther_public_password"] = "opensesame"
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(url)
        end

        it "fails authorization with nested path" do
          env["PATH_INFO"] = "/admin/nested/path"

          result = gatekeeper.call env
          expect(result[1]["Location"]).to eq(url)
        end
      end
    end

    context "with multiple accounts" do
      subject :gatekeeper do
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
          url: url,
          logger: logger
        )
      end

      let(:member_login) { cipher.encrypt "member" }
      let(:member_password) { cipher.encrypt "password" }
      let(:admin_login) { cipher.encrypt "admin" }
      let(:admin_password) { cipher.encrypt "for-your-eyes-only" }

      context "with non-excluded path" do
        it "passes authorization with authenticated account" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/public"

          result = gatekeeper.call env

          expect(result[1].key?("Location")).to be(false)
        end

        it "logs requested path" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Requested path "/member" found in excluded paths: ["/member", "/admin"].)
          )
        end

        it "logs account found" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with("[auther]: Account found.")
        end

        it "logs authentication passed" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Authentication passed. Account: "member".)
          )
        end

        it "logs authorization passed" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Authorization passed. Account: "member". Excludes: ["/member", "/admin"]. Request Path: "/member".)
          )
        end
      end

      context "with excluded path" do
        it "fails authorization with unauthenticated account" do
          env["PATH_INFO"] = "/member"
          result = gatekeeper.call env

          expect(result[1]["Location"]).to eq(url)
        end

        it "fails authorization with authenticated account" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"

          result = gatekeeper.call env

          expect(result[1]["Location"]).to eq(url)
        end

        it "logs account unknown" do
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with("[auther]: Account unknown.")
        end

        it "logs requested path" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = cipher.encrypt "bogus"
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Requested path "/member" found in excluded paths: ["/member", "/admin"].)
          )
        end

        it "logs account found" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = cipher.encrypt "bogus"
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with("[auther]: Account found.")
        end

        it "logs authentication failed" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = "bogus"
          env["PATH_INFO"] = "/member"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Authentication failed! Invalid credential(s) for "member" account.)
          )
        end

        it "logs authentication passed" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Authentication passed. Account: "member".)
          )
        end

        it "logs authorization failed" do
          env["rack.session"]["auther_member_login"] = member_login
          env["rack.session"]["auther_member_password"] = member_password
          env["PATH_INFO"] = "/admin"
          gatekeeper.call env

          expect(logger).to have_received(:info).with(
            %([auther]: Authorization failed! Account: "member". Excludes: ["/member", "/admin"]. Request Path: "/admin".)
          )
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
# rubocop:enable Metrics/LineLength
