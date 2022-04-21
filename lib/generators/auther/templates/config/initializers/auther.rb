# frozen_string_literal: true

Rails.application.config.auther_settings = {
  accounts: [
    {
      name: "admin",
      encrypted_login: ENV.fetch("AUTHER_ADMIN_LOGIN"),
      encrypted_password: ENV.fetch("AUTHER_ADMIN_PASSWORD"),
      paths: ["/admin"]
    }
  ],
  secret: ENV.fetch("AUTHER_SECRET")
}
