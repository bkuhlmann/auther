require "spec_helper"

RSpec.describe Auther::Account, type: :model do
  let(:parameters) do
    {
      name: "test",
      encrypted_login: "RUFKUVcyQzJCc1FoRyswZFpwN3JtNVNQR09JRVRadHd4S2pmekt4em90cz0tLTZpTlQxNnI5UzJnZlFpK3dYS1hjUVE9PQ==--d5546a942ad2dc509031f4c34429a016f8bd8612",
      encrypted_password: "eHdHL0lpUDVyV0p1MU0zWnlJQnk2aURTQW5kRE9nQnRHWGJSUFpkam1XWT0tLXo5Snd5R29nWFJwNTF4RkllTW5qZVE9PQ==--301aa47630d2134dedefbd57bcc685dd7686503e"
    }
  end

  subject { Auther::Account.new parameters }

  describe "#valid?" do
    it "answers true when name, encrypted login, and encrypted password are present" do
      expect(subject.valid?).to be(true)
    end

    it "answers true paths is an array" do
      subject.paths = []
      expect(subject.valid?).to be(true)
    end
  end

  describe "#invalid?" do
    it "answers true when name is not present" do
      subject.name = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when encrypted login is not present" do
      subject.encrypted_login = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when encrypted password is not present" do
      subject.encrypted_password = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when paths is not an array" do
      subject.paths = nil

      expect(subject.invalid?).to be(true)
      expect(subject.errors.full_messages).to include("Paths must be an array")
    end
  end
end
