# frozen_string_literal: true

require "active_model"

module Auther
  module Presenter
    # Adapter for presenting an account within a view.
    class Account
      include ActiveModel::Validations

      attr_accessor :name, :login, :password

      validates :name, :login, :password, presence: true

      def initialize name: "", login: "", password: ""
        @name = name
        @login = login
        @password = password
      end

      def error? key
        errors.key? key
      end

      def error_message key
        return "" unless error?(key)

        "#{key.capitalize} #{errors.messages[key].first}"
      end
    end
  end
end
