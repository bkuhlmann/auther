# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
Rails.application.config.auther_settings = {
  secret: "e751140a9dc94ffc8667e1c44d915ab2",
  accounts: [
    {
      name: "test",
      encrypted_login: "HPHY9Rufha6WQvtIcT+w--zqyQOGCKJRuoOeMi--DSk4Iu/vWmJXg1Wxrub8Lw==",
      encrypted_password: "p2T0dnGgYVgYy4j/4bX4AM5CtQ==--DCF/4rDZKDXhmHpe--ReIO9UkKEHkqf2ktsdGO4Q==",
      paths: ["/portal", "/trailer/"],
      authorized_url: "/portal/dashboard",
      deauthorized_url: "/deauthorized"
    }
  ]
}
# rubocop:enable Metrics/LineLength
