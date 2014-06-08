module Auther
  class BaseController < ActionController::Base
    def show
      redirect_to settings.auth_url
    end

    def new
      @account = Auther::Account.new
    end

    def create
      if account.valid?
        store_credentials
        redirect_to authorized_url
      else
        remove_credentials account.name
        render template: new_template_path
      end
    end

    def destroy
      account = settings.find_account params[:name]
      remove_credentials params[:name]
      redirect_to deauthorized_url(account)
    end

    private

    def settings
      Auther::Settings.new Rails.application.config.auther_settings
    end

    def load_title
      @title = settings.title
    end

    def load_label
      @label = settings.label
    end

    def load_account_options
      @account_options = settings.accounts.map do |account|
        name = account.fetch :name
        [name.capitalize, name]
      end
    end

    def account
      account_params = params.fetch :account
      account_settings = settings.find_account account_params.fetch(:name)

      @account ||= Auther::Account.new name: account_params.fetch(:name),
        login: account_params.fetch(:login),
        secure_login: account_settings.fetch(:login),
        password: account_params.fetch(:password),
        secure_password: account_settings.fetch(:password),
        secret: settings.secret,
        authorized_url: account_settings.fetch(:authorized_url, nil)
    end


    def new_template_path
      raise NotImplementedError, "The method, #new_template_path, is not implemented."
    end

    def authorized_url
      session["auther_redirect_url"] || account.authorized_url || '/'
    end

    def deauthorized_url account
      account[:deauthorized_url] || settings.auth_url
    end

    def store_credentials
      keymaster = Auther::Keymaster.new account.name
      session[keymaster.login_key] = account.secure_login
      session[keymaster.password_key] = account.secure_password
    end

    def remove_credentials name
      keymaster = Auther::Keymaster.new name
      session.delete keymaster.login_key
      session.delete keymaster.password_key
    end
  end
end
