class Auther::SessionController < ApplicationController
  layout "auther/auth"
  before_filter :name_options, only: [:new, :create]

  def show
    redirect_to action: :new
  end

  def new
    @account = Auther::Account.new
  end

  def create
    account_params = params.fetch(:account)
    @account = Auther::Account.new find_account(account_params.fetch(:name))

    if @account.valid?
      store_credentials @account, account_params.fetch(:login), account_params.fetch(:password)
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

  def name_options
    @name_options = settings.fetch(:accounts).map do |account|
      name = account.fetch :name
      [name.capitalize, name]
    end
  end

  def find_account name
    settings.fetch(:accounts).select { |account| account.fetch(:name) == name }.first
  end

  def store_credentials account, login, password
    keymaster = Auther::Keymaster.new account.name
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
