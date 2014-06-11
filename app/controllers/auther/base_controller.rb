module Auther
  class BaseController < ActionController::Base
    def show
      redirect_to settings.auth_url
    end

    def new
      @account_presenter = Auther::Presenter::Account.new
    end

    def create
      @account_presenter = Auther::Presenter::Account.new params[:account]
      account_model = Auther::Account.new settings.find_account(@account_presenter.name)
      authenticator = Auther::Authenticator.new settings.secret, account_model, @account_presenter

      if authenticator.authenticated?
        store_credentials account_model
        redirect_to authorized_url(account_model)
      else
        remove_credentials account_model
        render template: new_template_path
      end
    end

    def destroy
      account_model = Auther::Account.new settings.find_account(params[:name])
      remove_credentials account_model
      redirect_to deauthorized_url(account_model)
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

    def new_template_path
      raise NotImplementedError, "The method, #new_template_path, is not implemented."
    end

    def authorized_url account_model
      session["auther_redirect_url"] || account_model.authorized_url || '/'
    end

    def deauthorized_url account_model
      account_model.deauthorized_url || settings.auth_url
    end

    def store_credentials account_model
      keymaster = Auther::Keymaster.new account_model.name
      session[keymaster.login_key] = account_model.encrypted_login
      session[keymaster.password_key] = account_model.encrypted_password
    end

    def remove_credentials account_model
      keymaster = Auther::Keymaster.new account_model.name
      session.delete keymaster.login_key
      session.delete keymaster.password_key
    end
  end
end
