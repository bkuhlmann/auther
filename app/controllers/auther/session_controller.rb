class Auther::SessionController < ApplicationController
  layout "auther/auth"

  def show
    redirect_to action: :new
  end

  def new
  end

  def create
    settings = Rails.application.config.auther_settings
    account = settings.fetch(:accounts).select { |account| account.fetch(:name) == params[:name] }.first

    if account
      keymaster = Auther::Keymaster.new account[:name]
      cipher = Auther::Cipher.new account[:secret]
      session[keymaster.login_key] = cipher.encrypt params[:login]
      session[keymaster.password_key] = cipher.encrypt params[:password]
      redirect_to session["auther_redirect_url"] || '/'
    else
      render template: "auther/session/new"
    end
  end

  def destroy
    keymaster = Auther::Keymaster.new params[:name]
    session.delete keymaster.login_key
    session.delete keymaster.password_key
    redirect_to action: :new
  end
end
