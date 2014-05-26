require "spec_helper"

describe Auther::Gatekeeper do
  include Rack::Test::Methods

  let(:env) do
    {
      "rack.session" => {},
      "PATH_INFO" => "/"
    }
  end

  let(:app) do
    ->(env) { [200, env, ["OK"]] }
  end

  let(:secret) { "b%?A9mfswnd%PAXiKHcmR6WXz4(UG2t9W9sxkat7#uNBws}[s9Tuc;gDVfPV" }
  let(:auth_url) { "/login" }

  describe "single account" do
    let(:login) { "Yk5hMUdMdk10WWxQMUtsZFUyR2VEYzBWUm9hbHVsWndqVFNtM3ZCMWpOcz0tLWMvQjF2dlJ2OWo4VkkvYXlYMTYwUlE9PQ==--f53729f459527e944d20987c8159a06b56e4a736" }
    let(:password) { "S0F5V1prdWhXblkyd3pSTzZ5cTVuVFBDSU1QcWV2eGF6U3RLR2VVem9HND0tLUcvRkg1U25RZ3dxb01GeXNWV082TUE9PQ==--2ea7b64a2b08bf0d29aa767122451a98ff191370" }

    subject do
      Auther::Gatekeeper.new app, {
        accounts: [
          {
            name: "public",
            login: login,
            password: password,
            paths: [
              "/admin",
              "/member",
              "/trailing_slash/"
            ]
          }
        ],
        secret: secret,
        auth_url: auth_url
      }
    end

    context "non-blacklisted path" do
      it "allows access with no credentials" do
        env["PATH_INFO"] = "/some/random/path"

        result = subject.call env
        expect(result[1].has_key?("Location")).to eq(false)
      end

      it "allows access with valid credentials" do
        env["rack.session"]["auther_public_login"] = login
        env["rack.session"]["auther_public_password"] = password
        env["PATH_INFO"] = "/some/random/path"

        result = subject.call env
        expect(result[1].has_key?("Location")).to eq(false)
      end

      it "adds request path as request url to session" do
        path = "/admin"
        env["PATH_INFO"] = path

        result = subject.call env
        expect(env["rack.session"]["auther_redirect_url"]).to eq(path)
      end

      # NOTE: See Gatekeeper settings where trailing slash path is defined for this test.
      it "adds request (trailing slash) path as request url to session" do
        path = "/trailing_slash"
        env["PATH_INFO"] = path

        result = subject.call env
        expect(env["rack.session"]["auther_redirect_url"]).to eq(path)
      end

      it "does not log info message for requested path" do
        env["PATH_INFO"] = "/this/is/safe"

        expect(subject.logger).to receive(:info).never
        subject.call env
      end
    end

    context "blacklisted path" do
      it "denies access with no credentials" do
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with encrypted, invalid login" do
        env["rack.session"]["auther_public_login"] = "d1M3WmE4Zkp5RyttU1R0Q0dPMmhtNGxXY3E5YXRZMlJlTkZXTmFJK01BMD0tLVBSeU9NbjNwazRmUTd0VFNBUHZoTFE9PQ==--7a498efaaca3cee568c56dcc62ae7cd27fead46f"
        env["rack.session"]["auther_public_password"] = password
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with encrypted, invalid password" do
        env["rack.session"]["auther_public_login"] = login
        env["rack.session"]["auther_public_password"] = "MEVvazdyd3lBellGNWkzdEpyWE5ybWx2V1NZUEozTVBacW9sRzhrRWpYYz0tLVZ5OHphRGRUSTM1UDI3Sm9qdER6QXc9PQ==--12d865675f89334e4ffa9026724b7e62b11bf095"
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with unencrypted login" do
        env["rack.session"]["auther_public_login"] = "cracker"
        env["rack.session"]["auther_public_password"] = password
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with unencrypted password" do
        env["rack.session"]["auther_public_login"] = login
        env["rack.session"]["auther_public_password"] = "opensesame"
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with valid credentials" do
        env["rack.session"]["auther_public_login"] = login
        env["rack.session"]["auther_public_password"] = password
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access to nested path" do
        env["PATH_INFO"] = "/admin/nested/path"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "logs info message for requested path" do
        env["PATH_INFO"] = "/admin/nested/path"

        message = %(AUTHER: Requested path "/admin/nested/path" detected in blacklisted paths: ["/admin", "/member", "/trailing_slash"].)

        expect(subject.logger).to receive(:info).with(message).once
        subject.call env
      end
    end
  end

  describe "multiple accounts" do
    let(:public_login) { "Yk5hMUdMdk10WWxQMUtsZFUyR2VEYzBWUm9hbHVsWndqVFNtM3ZCMWpOcz0tLWMvQjF2dlJ2OWo4VkkvYXlYMTYwUlE9PQ==--f53729f459527e944d20987c8159a06b56e4a736" }
    let(:public_password) { "S0F5V1prdWhXblkyd3pSTzZ5cTVuVFBDSU1QcWV2eGF6U3RLR2VVem9HND0tLUcvRkg1U25RZ3dxb01GeXNWV082TUE9PQ==--2ea7b64a2b08bf0d29aa767122451a98ff191370" }
    let(:member_login) { "NGUzT2JIWUgybWwrc215UlpBUjBjcnRhS1g2SC8xQ0JkdkgvaXU0cERraz0tLVdLNGhqNnllMVZyTWFoZ3Btc3FiNFE9PQ==--57811a8a72d3c7ab8a6f95c8cea3aba6ac480749" }
    let(:member_password) { "UjFtVnJKVVlHQUR1WTlwaUNCR2JsQ3d4MWZ2Q2MvdnhhQ2ZWaU05SHVDaz0tLVV6TnRyek9td21GZ2w1MWhONmpYdlE9PQ==--0611996b09391cb22dd034f7f2046ca266eb0f65" }

    subject do
      Auther::Gatekeeper.new app, {
        accounts: [
          {
            name: "public",
            login: public_login,
            password: public_password,
            paths: [
              "/admin",
              "/member"
            ]
          },
          {
            name: "member",
            login: member_login,
            password: member_password,
            paths: [
              "/admin",
              "/contests/january"
            ]
          }
        ],
        secret: secret,
        auth_url: auth_url
      }
    end

    context "non-blacklisted path" do
      it "allows access with valid account" do
        env["rack.session"]["auther_member_login"] = member_login
        env["rack.session"]["auther_member_password"] = member_password
        env["PATH_INFO"] = "/member"

        result = subject.call env
        expect(result[1].has_key?("Location")).to eq(false)
      end
    end

    context "blacklisted path" do
      it "denies access for invalid account" do
        env["rack.session"]["auther_member_login"] = public_login
        env["rack.session"]["auther_member_password"] = public_password
        env["PATH_INFO"] = "/member"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "logs only blacklisted paths for valid account" do
        env["rack.session"]["auther_member_login"] = member_login
        env["rack.session"]["auther_member_password"] = member_password
        env["PATH_INFO"] = "/member"

        blacklist_message = %(AUTHER: Requested path "/member" detected in blacklisted paths: ["/admin", "/member", "/contests/january"].)
        account_message = %(AUTHER: Requested path "/member" blacklisted for "member" account.)

        expect(subject.logger).to receive(:info).with(blacklist_message).once
        subject.call env
      end

      it "logs blacklisted paths and account for valid account" do
        env["rack.session"]["auther_member_login"] = member_login
        env["rack.session"]["auther_member_password"] = member_password
        env["PATH_INFO"] = "/contests/january"

        blacklist_message = %(AUTHER: Requested path "/contests/january" detected in blacklisted paths: ["/admin", "/member", "/contests/january"].)
        account_message = %(AUTHER: Requested path "/contests/january" blacklisted for "member" account.)

        expect(subject.logger).to receive(:info).with(blacklist_message).once
        expect(subject.logger).to receive(:info).with(account_message).once
        subject.call env
      end
    end
  end
end
