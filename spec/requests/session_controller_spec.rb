# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::SessionController do
  describe "#show" do
    it "redirects to new action" do
      get "/auther/session"
      expect(response).to have_http_status(:found)
    end
  end

  describe "#new" do
    it "renders login form", :aggregate_failures do
      get "/auther/session/new"

      expect(response.body).to include("Login")
      expect(response.body).to include("Password")
    end

    it "renders login form with out errors" do
      get "/auther/session/new"
      expect(response.body).not_to include(%("auther-error"))
    end

    it "renders page title" do
      get "/auther/session/new"
      expect(response.body).to include("<title>Authorization</title>")
    end

    it "renders default label" do
      get "/auther/session/new"
      expect(response.body).to include(">Authorization</h1>")
    end
  end

  describe "#create" do
    let(:login) { "admin" }
    let(:password) { "nevermore" }
    let(:secret) { "e751140a9dc94ffc8667e1c44d915ab2" }
    let(:cipher) { Auther::Cipher.new secret }

    context "with valid credentials" do
      it "redirects to authorized URL", :aggregate_failures do
        post "/auther/session", params: {account: {name: "test", login:, password:}}

        expect(cipher.decrypt(session[:auther_test_login])).to eq(login)
        expect(cipher.decrypt(session[:auther_test_password])).to eq(password)
        expect(response.location).to eq("http://www.example.com/portal/dashboard")
      end

      it "requires excluded path authorization", :aggregate_failures do
        get "/portal"
        post "/auther/session", params: {account: {name: "test", login:, password:}}

        expect(cipher.decrypt(session[:auther_test_login])).to eq(login)
        expect(cipher.decrypt(session[:auther_test_password])).to eq(password)
      end

      it "redirects to requested path for excluded path" do
        get "/portal"
        post "/auther/session", params: {account: {name: "test", login:, password:}}

        expect(response.location).to eq("http://www.example.com/portal")
      end

      # See Dummy application.rb Auther settings where trailing slash path is defined.
      it "redirects to requested path for excluded (trailing slash) path" do
        get "/trailer"
        post "/auther/session", params: {account: {name: "test", login:, password:}}

        expect(response.location).to eq("http://www.example.com/trailer")
      end

      it "requires excluded path authorization and redirects to root path" do
        # Save and clear the authorized URL for the purposes of this test only.
        authorized_url = Rails.application.config.auther_settings[:accounts].first[:authorized_url]
        Rails.application.config.auther_settings[:accounts].first[:authorized_url] = ""

        post "/auther/session", params: {account: {name: "test", login:, password:}}

        # Restore the authorized URL so that other tests are not affected by modified configuration.
        Rails.application.config.auther_settings[:accounts].first[:authorized_url] = authorized_url

        expect(response.location).to eq("http://www.example.com")
      end
    end

    context "with invalid credentials" do
      let :parameters do
        {
          account: {
            name: "test",
            login:,
            password:
          }
        }
      end

      let(:login) { "invalid@example.com" }
      let(:password) { "bogus" }

      it "renders errors", :aggregate_failures do
        post "/auther/session", params: parameters

        expect(response.body).to include("auther-error")
        expect(response.body).to include(%(value="invalid@example.com"))
      end

      it "removes login session credential" do
        post "/auther/session", params: parameters
        expect(session.key?(:auther_test_login)).to be(false)
      end

      it "removes password session credential" do
        post "/auther/session", params: parameters
        expect(session.key?(:auther_test_password)).to be(false)
      end

      it "answers OK status" do
        post "/auther/session", params: parameters
        expect(response).to have_http_status(:ok)
      end

      it "requires excluded path authorization and remembers request path" do
        get "/portal"
        post "/auther/session", params: parameters

        expect(session[:auther_redirect_url]).to eq("/portal")
      end
    end

    context "with nil credentials" do
      let :parameters do
        {
          account: {
            name: "test",
            login: nil,
            password: nil
          }
        }
      end

      it "renders errors" do
        post "/auther/session", params: parameters
        expect(response.body).to include("auther-error")
      end
    end
  end

  describe "#destroy" do
    let :parameters do
      {
        account: {
          name: "test",
          login: "test@test.com",
          password: "itsasecret"
        }
      }
    end

    it "destroys credentials", :aggregate_failures do
      post "/auther/session", params: parameters
      delete "/auther/session", params: {name: "test"}

      expect(session.key?(:auther_test_login)).to be(false)
      expect(session.key?(:auther_test_password)).to be(false)
    end

    # rubocop:disable RSpec/ExampleLength
    it "redirects to default deauthorized URL" do
      # Save and clear the authorized URL for the purposes of this test only.
      deauthorized_url = Rails.application
                              .config
                              .auther_settings[:accounts]
                              .first[:deauthorized_url]
      Rails.application.config.auther_settings[:accounts].first[:deauthorized_url] = nil

      post "/auther/session", params: parameters
      delete "/auther/session", params: {name: "test"}

      # Restore authorized URL so other tests are not affected by the modified configuration.
      Rails.application
           .config
           .auther_settings[:accounts]
           .first[:deauthorized_url] = deauthorized_url

      expect(response.location).to eq("http://www.example.com/login")
    end
    # rubocop:enable RSpec/ExampleLength

    it "redirects to account deauthorized URL" do
      post "/auther/session", params: parameters
      delete "/auther/session", params: {name: "test"}

      expect(response.location).to eq("http://www.example.com/deauthorized")
    end
  end
end
