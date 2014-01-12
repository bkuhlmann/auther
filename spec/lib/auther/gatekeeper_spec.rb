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
    let(:login) { "Yk5hMUdMdk10WWxQMUtsZFUyR2VEYzBWUm9hbHVsWndqVFNtM3ZCMWpOcz0tLWMvQjF2dlJ2OWo4VkkvYXlYMTYwUlE9PQ==--f53729f459527e944d20987c8159a06b56e4a736" }
    let(:password) { "S0F5V1prdWhXblkyd3pSTzZ5cTVuVFBDSU1QcWV2eGF6U3RLR2VVem9HND0tLUcvRkg1U25RZ3dxb01GeXNWV082TUE9PQ==--2ea7b64a2b08bf0d29aa767122451a98ff191370" }

    subject do
      Auther::Gatekeeper.new app, {
        accounts: [
          {
            name: "public",
            login: login,
            password: password,
            secret: "b%?A9mfswnd%PAXiKHcmR6WXz4(UG2t9W9sxkat7#uNBws}[s9Tuc;gDVfPV",
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
    end
  end

  describe "multiple accounts" do
    let(:public_login) { "bFRSRi9GdVh3YUxMY2Q2TGo1NWlhRmlZTmZsMmZXWnhrcmRQRS9DSlFZVT0tLWtLU3EzclJBcXdRQ1hPVG1EU0k3SHc9PQ==--331d8fda2272f4754de3e3180dabba81d83cd763" }
    let(:public_password) { "b2ZKOEtrQWx1YnVoQUV0d2R2dmF2aVVkNUJSNUQxb21KMjdFaDhhSGlOMD0tLWdvWFdPYjdoazA2TWRzVWxxaE5zRmc9PQ==--dc2518aeff63f613b337485307c069467c1bcc19" }
    let(:member_login) { "dkpFMUVpM3lvS3Jla2tNTTFZR2h4R0M5cU1kQWVZSGs0U0lMOUNFUjBJRT0tLXBVMzhIZGFaOG9Yd3NwTEp6T0lWVXc9PQ==--c406e10e0deaac891ca9b0c447b3b6a31e166fd0" }
    let(:member_password) { "T2l3QnB4RFpxT1puNXFDSnZ2b0Y1T29GS1BmSW1nMmJYelRlUit1SHRURT0tLWxBNERqS2R6NThLaWprNWE4TDZaZHc9PQ==--3bb5576fa6c2c83368add1e092928ae656a6acbd" }

    subject do
      Auther::Gatekeeper.new app, {
        accounts: [
          {
            name: "public",
            login: public_login,
            password: public_password,
            secret: "%[4DWtyxW7Y[GieQZdv}e9WEcxyN6FftUiVb7WWGc3Xf+3TVX4LR/qKVW]*a",
            paths: [
              "/admin",
              "/member"
            ]
          },
          {
            name: "member",
            login: member_login,
            password: member_password,
            secret: "^mQ2dd7$2TJcEsA?Yax2Asr(WGkrFycT.HU4hk,h@uZ$Db7fAvn2wNH3wZDR",
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
