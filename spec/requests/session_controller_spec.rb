require "spec_helper"

describe Auther::SessionController do
  describe "#show" do
    it "redirects to new action" do
      get "/auther/session"
      expect(response.status).to eq 302
    end
  end

  describe "#new" do
    it "renders login form" do
      get "/auther/session/new"

      expect(response.status).to eq 200
      expect(response.body).to include("Login:")
      expect(response.body).to include("Password:")
    end
  end

  describe "#create" do
    it "redirects to root path with valid credentials" do
      post "/auther/session", login: "test@test.com", password: "password"

      expect(session[:auther_test_login]).to eq("test@test.com")
      expect(session[:auther_test_password]).to eq("password")
      expect(response.status).to eq 302
      expect(response.location).to include("www.example.com/")
    end

    it "redirects with invalid credentials" do
      post "/auther/session", login: "test@test.com", password: "bogus"

      expect(session[:auther_test_login]).to eq("test@test.com")
      expect(session[:auther_test_password]).to eq("bogus")
      expect(response.status).to eq 302
    end

    it "renders errors with invalid credentials"

    it "requires authorization and redirects to original path when credentials are valid" do
      get "/portal"
      post "/auther/session", login: "test@test.com", password: "password"

      expect(session[:auther_test_login]).to eq("test@test.com")
      expect(session[:auther_test_password]).to eq("password")
      expect(response.status).to eq 302
      expect(response.location).to include("portal")
    end

    it "requires authorization and redirects when credentials are invalid" do
      get "/portal"
      post "/auther/session", login: "test@test.com", password: "bogus"

      expect(session[:auther_test_login]).to eq("test@test.com")
      expect(session[:auther_test_password]).to eq("bogus")
      expect(response.status).to eq 302
    end
  end

  describe "#destroy" do
    it "destroys credentials and redirects to new action" do
      post "/auther/session", login: "test@test.com", password: "password"
      delete "/auther/session", account_name: "test"

      expect(session.has_key? :auther_test_login).to eq(false)
      expect(session.has_key? :auther_test_password).to eq(false)
      expect(response.status).to eq 302
    end
  end
end
