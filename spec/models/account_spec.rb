require "spec_helper"

describe Auther::Account do
  let(:parameters) do
    {
      name: "test",
      login: "test@test.com",
      secure_login: "RUFKUVcyQzJCc1FoRyswZFpwN3JtNVNQR09JRVRadHd4S2pmekt4em90cz0tLTZpTlQxNnI5UzJnZlFpK3dYS1hjUVE9PQ==--d5546a942ad2dc509031f4c34429a016f8bd8612",
      password: "nevermore",
      secure_password: "eHdHL0lpUDVyV0p1MU0zWnlJQnk2aURTQW5kRE9nQnRHWGJSUFpkam1XWT0tLXo5Snd5R29nWFJwNTF4RkllTW5qZVE9PQ==--301aa47630d2134dedefbd57bcc685dd7686503e",
      secret: "jBiaeSgIb4qBUmLne4TiXQrmghedqayXC7esJcdpgWNdEiFN2o6fWdk8TzNS6nv0GifypoIejQn82Q5hEkICyTejsUqTn&ohz?2n"
    }
  end

  subject { Auther::Account.new parameters }

  describe "#valid?" do
    it "is valid when name, login, secure_login, password, secure_password, and secret are present" do
      expect(subject.valid?).to eq(true)
    end
  end

  describe "#invalid?" do
    it "is invalid when name is not present" do
      subject.name = nil
      expect(subject.invalid?).to eq(true)
    end

    it "is invalid when login is not present" do
      subject.login = nil
      expect(subject.invalid?).to eq(true)
    end

    it "is invalid when secure login is not present" do
      parameters.delete :secure_login
      subject = Auther::Account.new parameters
      subject.valid?

      expect(subject.invalid?).to eq(true)
      expect(subject.errors.full_messages).to include("Login is invalid")
    end

    it "is invalid when password is not present" do
      subject.password = nil
      expect(subject.invalid?).to eq(true)
    end

    it "is invalid when secure password is not present" do
      parameters.delete :secure_password
      subject = Auther::Account.new parameters

      expect(subject.invalid?).to eq(true)
      expect(subject.errors.full_messages).to include("Password is invalid")
    end

    it "is invalid when paths is not an array" do
      subject.paths = nil

      expect(subject.invalid?).to eq(true)
      expect(subject.errors.full_messages).to include("Paths must be an array")
    end

    it "is invalid when secret is not present" do
      parameters.delete :secret
      subject = Auther::Account.new parameters

      expect(subject.invalid?).to eq(true)
    end
  end
end
