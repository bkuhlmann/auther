# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
Rails.application.config.auther_settings = {
  secret: "\xE4]c\xE8ȿOh%\xB5\xF4\xD5\u0012\xB0\u000F\xF0\xF8Í\xFCKZ\u0000R~9\u0019\xE3\u0011xk\xB2",
  accounts: [
    {
      name: "test",
      encrypted_login: "ZzNEY0gxWVdEQzdBTmppWnFNbGwvQT09LS1ZSWdwUFU5VklyVWY1cjJNS0FBWUJ3PT0=--4498bdb1461305d9ef218f7886bd903d00c44ce0",
      encrypted_password: "OXRlRkpMTEsxbGJuQnVUNHRMSFgvRVhLREFJeW9hNzRzNFBId2kzeSs4QT0tLWJYakVRd0pXR1JQeXFyL0NVSk1XbWc9PQ==--d5bc91dcdb9117a2edbdba7e3cf8b4f3b53d09f5",
      paths: ["/portal", "/trailer/"],
      authorized_url: "/portal/dashboard",
      deauthorized_url: "/deauthorized"
    }
  ]
}
# rubocop:enable Metrics/LineLength
