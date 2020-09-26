# frozen_string_literal: true

require "securerandom"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.shared_context "with credentials", :credentials do
  let(:login) { "tester" }
  let(:password) { "nevermore" }
  let(:credentials) { Auther::Cipher.generate login, password }
  let(:secret) { credentials.fetch :secret }
  let(:cipher) { Auther::Cipher.new secret }
  let(:encrypted_login) { credentials.fetch :login }
  let(:encrypted_password) { credentials.fetch :password }
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
