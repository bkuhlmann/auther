# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::SessionController, type: :request do
  describe "#show" do
    it "redirects to new action" do
      get "/auther/session"
      expect(response.status).to eq 302
    end
  end

  describe "#new" do
    it "renders login form", :aggregate_failures do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include("Login")
      expect(response.body).to include("Password")
    end

    it "renders page title", :aggregate_failures do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include("<title>Authorization</title>")
    end

    it "renders default label", :aggregate_failures do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include(">Authorization</h1>")
    end
  end

  describe "#create" do
    let(:login) { "admin" }
    let(:password) { "nevermore" }

    let :secret do
      "\xE4]c\xE8ȿOh%\xB5\xF4\xD5\u0012\xB0\u000F\xF0\xF8Í\xFCKZ\u0000R~9\u0019\xE3\u0011xk\xB2"
    end

    let(:cipher) { Auther::Cipher.new secret }

    context "valid credentials" do
      it "redirects to authorized URL", :aggregate_failures do
        post "/auther/session", params: {account: {name: "test", login: login, password: password}}

        expect(response.status).to eq 302
        expect(cipher.decrypt(session[:auther_test_login])).to eq(login)
        expect(cipher.decrypt(session[:auther_test_password])).to eq(password)
        expect(response.location).to eq("http://www.example.com/portal/dashboard")
      end

      it "requires excluded path authorization and redirects to requested path", :aggregate_failures do
        get "/portal"
        post "/auther/session", params: {account: {name: "test", login: login, password: password}}

        expect(response.status).to eq 302
        expect(cipher.decrypt(session[:auther_test_login])).to eq(login)
        expect(cipher.decrypt(session[:auther_test_password])).to eq(password)
        expect(response.location).to eq("http://www.example.com/portal")
      end

      # NOTE: See Dummy application.rb Auther settings where trailing slash path is defined.
      it "requires excluded (trailing slash) path auth and redirects to requested path", :aggregate_failures do
        get "/trailer"
        post "/auther/session", params: {account: {name: "test", login: login, password: password}}

        expect(response.status).to eq 302
        expect(response.location).to eq("http://www.example.com/trailer")
      end

      it "requires excluded path authorization and redirects to root path", :aggregate_failures do
        # Save and clear the authorized URL for the purposes of this test only.
        authorized_url = Rails.application.config.auther_settings[:accounts].first[:authorized_url]
        Rails.application.config.auther_settings[:accounts].first[:authorized_url] = ""

        post "/auther/session", params: {account: {name: "test", login: login, password: password}}

        # Restore the authorized URL so that other tests are not affected by modified configuration.
        Rails.application.config.auther_settings[:accounts].first[:authorized_url] = authorized_url

        expect(response.status).to eq 302
        expect(response.location).to eq("http://www.example.com")
      end
    end

    context "invalid credentials" do
      it "renders errors with missing login and password", :aggregate_failures do
        post "/auther/session", params: {account: {name: "test", login: nil, password: nil}}

        expect(response.status).to eq 200
        expect(response.body).to include("auther-error")
      end

      it "renders errors with invalid login and password", :aggregate_failures do
        post "/auther/session", params: {
          account: {
            name: "test",
            login: "bogus@test.com",
            password: "bogus-password"
          }
        }

        expect(response.status).to eq 200
        expect(response.body).to include("auther-error")
        expect(response.body).to include(%(value="bogus@test.com"))
      end

      it "removes session credentials", :aggregate_failures do
        post "/auther/session", params: {
          account: {
            name: "test",
            login: "bogus@test.com",
            password: nil
          }
        }

        expect(response.status).to eq 200
        expect(session.key?(:auther_test_login)).to be(false)
        expect(session.key?(:auther_test_password)).to be(false)
      end

      it "requires excluded path authorization and remembers request path", :aggregate_failures do
        get "/portal"
        post "/auther/session", params: {account: {name: "test", login: login, password: "bogus"}}

        expect(response.status).to eq 200
        expect(session[:auther_redirect_url]).to eq("/portal")
        expect(response.body).to include("auther-error")
        expect(response.body).to include(%(value="#{login}"))
      end
    end
  end

  describe "#destroy" do
    it "destroys credentials", :aggregate_failures do
      post "/auther/session", params: {
        account: {
          name: "test",
          login: "test@test.com",
          password: "itsasecret"
        }
      }

      delete "/auther/session", params: {name: "test"}

      expect(session.key?(:auther_test_login)).to be(false)
      expect(session.key?(:auther_test_password)).to be(false)
    end

    it "redirects to default deauthorized URL", :aggregate_failures do
      # Save and clear the authorized URL for the purposes of this test only.
      deauthorized_url = Rails.application
                              .config
                              .auther_settings[:accounts]
                              .first[:deauthorized_url]
      Rails.application.config.auther_settings[:accounts].first[:deauthorized_url] = nil

      post "/auther/session", params: {
        account: {
          name: "test",
          login: "test@test.com",
          password: "itsasecret"
        }
      }

      delete "/auther/session", params: {name: "test"}

      # Restore authorized URL so other tests are not affected by the modified configuration.
      Rails.application
           .config
           .auther_settings[:accounts]
           .first[:deauthorized_url] = deauthorized_url

      expect(response.status).to eq 302
      expect(response.location).to eq("http://www.example.com/login")
    end

    it "redirects to account deauthorized URL", :aggregate_failures do
      post "/auther/session", params: {
        account: {
          name: "test",
          login: "test@test.com",
          password: "itsasecret"
        }
      }

      delete "/auther/session", params: {name: "test"}

      expect(response.status).to eq 302
      expect(response.location).to eq("http://www.example.com/deauthorized")
    end
  end
end
