require "spec_helper"

describe Auther::SessionController, :type => :request do
  describe "#show" do
    it "redirects to new action" do
      get "/auther/session"
      expect(response.status).to eq 302
    end
  end

  describe "#new" do
    before :each do
      Rails.application.config.auther_settings.delete :title
      Rails.application.config.auther_settings.delete :label
    end

    it "renders login form" do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include("Login:")
      expect(response.body).to include("Password:")
    end

    it "renders default page title" do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include("<title>Authorization</title>")
    end

    it "renders custom page title" do
      Rails.application.config.auther_settings[:title] = "Dummy"
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include("<title>Dummy</title>")
    end

    it "renders default page label" do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include(">Authorization</h1>")
    end

    it "renders custom page label" do
      Rails.application.config.auther_settings[:label] = "Dummy"
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include(">Dummy</h1>")
    end
  end

  describe "#create" do
    let(:login) { "test@test.com" }
    let(:password) { "itsasecret" }
    let(:cipher) { Auther::Cipher.new "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb" }

    it "redirects to success URL with valid credentials" do
      post "/auther/session", account: {name: "test", login: login, password: password}

      expect(response.status).to eq 302
      expect(cipher.decrypt(session[:auther_test_login])).to eq(login)
      expect(cipher.decrypt(session[:auther_test_password])).to eq(password)
      expect(response.location).to eq("http://www.example.com/portal/dashboard")
    end

    it "renders errors with missing credentials" do
      post "/auther/session", account: {name: "test", login: nil, password: nil}

      expect(response.status).to eq 200
      expect(response.body).to include("field_with_errors")
    end

    it "renders errors with invalid credentials" do
      post "/auther/session", account: {name: "test", login: "bogus@test.com", password: "bogus-password"}

      expect(response.status).to eq 200
      expect(response.body).to include("field_with_errors")
      expect(response.body).to include(%(value="bogus@test.com"))
    end

    it "removes session credentials with missing/invalid credentials" do
      post "/auther/session", account: {name: "test", login: "bogus@test.com", password: nil}

      expect(response.status).to eq 200
      expect(session.has_key? :auther_test_login).to eq(false)
      expect(session.has_key? :auther_test_password).to eq(false)
    end

    it "requires blacklisted path authorization and redirects to requested path with valid credentials" do
      get "/portal"
      post "/auther/session", account: {name: "test", login: login, password: password}

      expect(response.status).to eq 302
      expect(cipher.decrypt(session[:auther_test_login])).to eq(login)
      expect(cipher.decrypt(session[:auther_test_password])).to eq(password)
      expect(response.location).to eq("http://www.example.com/portal")
    end

    # NOTE: See Dummy application.rb Auther settings where trailing slash path is defined for this test.
    it "requires blacklisted (trailing slash) path authorization and redirects to requested path with valid credentials" do
      get "/trailer"
      post "/auther/session", account: {name: "test", login: login, password: password}

      expect(response.status).to eq 302
      expect(response.location).to eq("http://www.example.com/trailer")
    end

    it "requires blacklisted path authorization and redirects to root path with valid credentials" do
      # Save and clear the success URL for the purposes of this test only.
      success_url = Rails.application.config.auther_settings[:accounts].first[:success_url]
      Rails.application.config.auther_settings[:accounts].first[:success_url] = ''

      post "/auther/session", account: {name: "test", login: login, password: password}

      # Restore the success URL so that other tests are not affected by the modified configuration.
      Rails.application.config.auther_settings[:accounts].first[:success_url] = success_url

      expect(response.status).to eq 302
      expect(response.location).to eq("http://www.example.com")
    end

    it "requires blacklisted path authorization and remembers request path with invalid credentials" do
      get "/portal"
      post "/auther/session", account: {name: "test", login: login, password: "bogus"}

      expect(response.status).to eq 200
      expect(session[:auther_redirect_url]).to eq("/portal")
      expect(response.body).to include("field_with_errors")
      expect(response.body).to include(%(value="#{login}"))
    end
  end

  describe "#destroy" do
    it "destroys credentials and redirects to new action" do
      post "/auther/session", account: {name: "test", login: "test@test.com", password: "password"}
      delete "/auther/session", name: "test"

      expect(response.status).to eq 302
      expect(session.has_key? :auther_test_login).to eq(false)
      expect(session.has_key? :auther_test_password).to eq(false)
    end
  end
end
