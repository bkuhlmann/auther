# frozen_string_literal: true

module Auther
  # Abstract controller for session management.
  class BaseController < ActionController::Base
    protect_from_forgery with: :exception

    def show
      redirect_to settings.auth_url
    end

    def new
      @account = Auther::Presenter::Account.new
    end

    # rubocop:disable Metrics/AbcSize
    def create
      @account = Auther::Presenter::Account.new account_params.to_h.symbolize_keys
      account = Auther::Account.new settings.find_account(@account.name)
      authenticator = Auther::Authenticator.new settings.secret, account, @account

      if authenticator.authenticated?
        store_credentials account
        redirect_to authorized_url(account)
      else
        remove_credentials account
        render template: new_template_path
      end
    end
    # rubocop:enable Metrics/AbcSize

    def destroy
      account = Auther::Account.new settings.find_account(params[:name])
      remove_credentials account
      redirect_to deauthorized_url(account)
    end

    private

    def account_params
      params.require(:account).permit(:name, :login, :password)
    end

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

    def new_template_path
      fail NotImplementedError, "The method, #new_template_path, is not implemented."
    end

    def authorized_url account
      session["auther_redirect_url"] || account.authorized_url || "/"
    end

    def deauthorized_url account
      account.deauthorized_url || settings.auth_url
    end

    def store_credentials account
      keymaster = Auther::Keymaster.new account.name
      session[keymaster.login_key] = account.encrypted_login
      session[keymaster.password_key] = account.encrypted_password
    end

    def remove_credentials account
      keymaster = Auther::Keymaster.new account.name
      session.delete keymaster.login_key
      session.delete keymaster.password_key
    end
  end
end
