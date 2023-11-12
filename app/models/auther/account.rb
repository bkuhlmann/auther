# frozen_string_literal: true

require "active_model"

module Auther
  # Represents an authenticatable account.
  Account = Struct.new(
    :name,
    :encrypted_login,
    :encrypted_password,
    :paths,
    :authorized_url,
    :deauthorized_url,
    keyword_init: true
  ) do
    include ActiveModel::Validations

    validates :name, :encrypted_login, :encrypted_password, presence: true
    validate :paths_type

    def initialize *arguments
      super
      self[:paths] ||= []
    end

    private

    def paths_type = (errors.add :paths, "must be an array" unless paths.is_a? Array)
  end
end
