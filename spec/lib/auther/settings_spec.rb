require "spec_helper"

describe Auther::Settings do
  let :settings do
    {
      secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
      accounts: [
        name: "test",
        login: "test@test.com",
        secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
        secure_login: "RUFKUVcyQzJCc1FoRyswZFpwN3JtNVNQR09JRVRadHd4S2pmekt4em90cz0tLTZpTlQxNnI5UzJnZlFpK3dYS1hjUVE9PQ==--d5546a942ad2dc509031f4c34429a016f8bd8612",
        password: "nevermore",
        secure_password: "eHdHL0lpUDVyV0p1MU0zWnlJQnk2aURTQW5kRE9nQnRHWGJSUFpkam1XWT0tLXo5Snd5R29nWFJwNTF4RkllTW5qZVE9PQ==--301aa47630d2134dedefbd57bcc685dd7686503e",
        paths: ["/admin"]
      ]
    }
  end

  subject { Auther::Settings.new settings }

  describe "#initialize" do
    context "defaults" do
      it "sets default title" do
        expect(subject.title).to eq("Authorization")
      end

      it "sets default label" do
        expect(subject.title).to eq("Authorization")
      end

      it "sets default auth URL" do
        expect(subject.auth_url).to eq("/login")
      end

      it "sets default logger" do
        expect(subject.logger).to be_a(Auther::NullLogger)
      end
    end

    context "custom" do
      let :settings do
        {
          title: "Test",
          label: "Test",
          secret: "eSgIb4qBUmLneTiXQrmghyXTQq7wfopf9wYaDLGBh3e2RYp9DRayCogYbmDBj4Z78xWQKmoq4bY2WPGPXuf48RqXiW2RbKV3wPmJ",
          accounts: [],
          auth_url: "/test",
          logger: Logger.new(STDOUT)
        }
      end

      subject { Auther::Settings.new settings }

      it "sets default title" do
        expect(subject.title).to eq("Test")
      end

      it "sets default label" do
        expect(subject.title).to eq("Test")
      end

      it "sets default auth URL" do
        expect(subject.auth_url).to eq("/test")
      end

      it "sets default logger" do
        expect(subject.logger).to be_a(Logger)
      end
    end
  end
end
