module Auther
  class Account
    include ActiveModel::Validations

    attr_accessor :name, :login, :password, :paths

    validates :name, :login, :password, presence: true
    validates :paths, presence: {unless: lambda { |account| account.paths.is_a? Array }, message: "must be an array"}

    def initialize name: nil, login: nil, password: nil, paths: []
      @name = name
      @login = login
      @password = password
      @paths = paths
    end
  end
end
