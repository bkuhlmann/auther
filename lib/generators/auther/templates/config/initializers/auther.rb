Rails.application.config.auther_settings = {
  secret: ENV["AUTHER_SECRET"],
  accounts: [
    name: "admin",
    encrypted_login: ENV["AUTHER_ADMIN_LOGIN"],
    encrypted_password: ENV["AUTHER_ADMIN_PASSWORD"],
    paths: ["/admin"]
  ]
}
