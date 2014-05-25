module Auther
  class BaseController < ActionController::Base
    def show
      redirect_to settings[:auth_url]
    end

    def new
      @account = Auther::Account.new
    end

    def create
      if account.valid?
        store_credentials
        redirect_to session["auther_redirect_url"] || '/'
      else
        remove_credentials account.name
        render template: new_template_path
      end
    end

    def destroy
      remove_credentials params[:name]
      redirect_to settings[:auth_url]
    end

    private

    def load_title
      @title = settings.fetch :title, "Authorization"
    end

    def load_label
      @label = settings.fetch :label, "Authorization"
    end

    def settings
      Rails.application.config.auther_settings
    end

    def account
      account_params = params.fetch :account
      account_settings = find_account account_params.fetch(:name)

      @account ||= Auther::Account.new name: account_params.fetch(:name),
        login: account_params.fetch(:login),
        secure_login: account_settings.fetch(:login),
        password: account_params.fetch(:password),
        secure_password: account_settings.fetch(:password),
        secret: settings.fetch(:secret)
    end

    def name_options
      @name_options = settings.fetch(:accounts).map do |account|
        name = account.fetch :name
        [name.capitalize, name]
      end
    end

    def new_template_path
      raise NotImplementedError, "The method, #new_template_path, is not implemented."
    end

    def find_account name
      settings.fetch(:accounts).select { |account| account.fetch(:name) == name }.first
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
