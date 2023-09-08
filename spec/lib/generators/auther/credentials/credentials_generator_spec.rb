# frozen_string_literal: true

require "rails_helper"
require File.join(Dir.pwd, "lib/generators/auther/credentials/credentials_generator")

RSpec.describe Auther::CredentialsGenerator, type: :generator do
  describe "#credentials" do
    before { allow($stdin).to receive(:gets).and_return("test").twice }

    it "accepts input and prints generated credentials" do
      expect(run_generator).to match(
        /
          \s{2}Enter\sadmin\slogin:\s.+
          \s{2}Enter\sadmin\spassword:\s.+
          \s{2}AUTHER_SECRET=[0-9a-f]{#{Auther::Cipher.key_length}}.+
          \s{2}AUTHER_ADMIN_LOGIN=.+
          \s{2}AUTHER_ADMIN_PASSWORD=.+
        /xm
      )
    end
  end
end
