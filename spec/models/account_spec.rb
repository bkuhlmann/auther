require "spec_helper"

describe Auther::Account do
  subject { Auther::Account.new name: "test", login: "test@test.com", password: "nevermore" }

  describe "#valid?" do
    it "is valid when name, login, and password are present" do
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

    it "is invalid when password is not present" do
      subject.password = nil
      expect(subject.invalid?).to eq(true)
    end

    it "is invalid when paths is not an array" do
      subject.paths = nil

      expect(subject.invalid?).to eq(true)
      expect(subject.errors.full_messages).to include("Paths must be an array")
    end
  end
end
