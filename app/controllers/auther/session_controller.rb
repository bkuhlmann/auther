class Auther::SessionController < ApplicationController
  layout "auther/auth"

  def show
    redirect_to action: :new
  end

  def new
  end

  def create
    account = find_account params[:name]

    if account
      store_credentials account, params[:login], params[:password]
      redirect_to session["auther_redirect_url"] || '/'
    else
      render template: "auther/session/new"
    end
  end

  def destroy
    remove_credentials params[:name]
    redirect_to action: :new
  end

  private

  def settings
    Rails.application.config.auther_settings
  end

  def find_account name
    settings.fetch(:accounts).select { |account| account.fetch(:name) == name }.first
  end

  def store_credentials account, login, password
    keymaster = Auther::Keymaster.new account[:name]
    cipher = Auther::Cipher.new settings.fetch(:secret)
    session[keymaster.login_key] = cipher.encrypt login
    session[keymaster.password_key] = cipher.encrypt password
  end

  def remove_credentials name
    keymaster = Auther::Keymaster.new name
    session.delete keymaster.login_key
    session.delete keymaster.password_key
  end
end
