# frozen_string_literal: true

require "securerandom"

RSpec.shared_context "Credentials", :credentials do
  let(:secret) { SecureRandom.random_bytes 32 }
  let(:cipher) { Auther::Cipher.new secret }
  let(:encrypted_login) { cipher.encrypt "tester" }
  let(:encrypted_password) { cipher.encrypt "nevermore" }
end
