class Auther::SessionController < ApplicationController
  layout "auther/auth"

  def show
    redirect_to action: :new
  end

  def new
  end

  def create
    settings = Rails.application.config.auther_settings
    account = settings.fetch(:accounts).select { |account| account.fetch(:login) == params[:login] }.first

    if account
      keymaster = Auther::Keymaster.new account[:name]
      session[keymaster.login_key] = params[:login]
      session[keymaster.password_key] = params[:password]
      redirect_to session["auther_redirect_url"] || '/'
    else
      render template: "auther/session/new"
    end
  end

  def destroy
    keymaster = Auther::Keymaster.new params[:account_name]
    session.delete keymaster.login_key
    session.delete keymaster.password_key
    redirect_to action: :new
  end
end
