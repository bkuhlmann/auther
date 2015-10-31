require "active_model"

module Auther
  module Presenter
    # Adapter for presenting an account within a view.
    class Account
      include ActiveModel::Validations

      attr_accessor :name, :login, :password

      validates :name, :login, :password, presence: true

      def initialize options = {}
        @name = options[:name]
        @login = options[:login]
        @password = options[:password]
      end
    end
  end
end
