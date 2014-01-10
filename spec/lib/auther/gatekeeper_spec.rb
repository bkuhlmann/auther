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

  let(:auth_url) { "/login" }

  describe "single account" do
    let(:login) { "public@test.com" }
    let(:password) { "password" }

    subject do
      Auther::Gatekeeper.new app, {
        accounts: [
          {
            name: "public",
            login: login,
            password: password,
            paths: [
              "/admin",
              "/member"
            ]
          }
        ],
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
        pending "Test redirect url" do
          path = "/admin"
          env["PATH_INFO"] = path

          result = subject.call env
          expect(result[1]["rack.session"]["auther_redirect_url"]).to eq(path)
        end
      end
    end

    context "blacklisted path" do
      it "denies access with no credentials" do
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with invalid login" do
        env["rack.session"]["auther_public_login"] = "cracker@cracker.com"
        env["rack.session"]["auther_public_password"] = password
        env["PATH_INFO"] = "/admin"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end

      it "denies access with invalid password" do
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
    end
  end

  describe "multiple accounts" do
    let(:public_login) { "public@test.com" }
    let(:public_password) { "password" }
    let(:member_login) { "member@test.com" }
    let(:member_password) { "drowssap" }

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
        auth_url: auth_url
      }
    end

    context "non-blacklisted account path" do
      it "allows access with valid account" do
        env["rack.session"]["auther_member_login"] = member_login
        env["rack.session"]["auther_member_password"] = member_password
        env["PATH_INFO"] = "/member"

        result = subject.call env
        expect(result[1].has_key?("Location")).to eq(false)
      end
    end

    context "blacklisted account path" do
      it "denies access for invalid account" do
        env["rack.session"]["auther_member_login"] = public_login
        env["rack.session"]["auther_member_password"] = public_password
        env["PATH_INFO"] = "/member"

        result = subject.call env
        expect(result[1]["Location"]).to eq(auth_url)
      end
    end
  end
end
