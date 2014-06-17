require "spec_helper"

describe Auther::Presenter::Account, type: :model do
  let(:parameters) do
    {
      name: "test",
      login: "test@test.com",
      password: "nevermore"
    }
  end

  subject { Auther::Presenter::Account.new parameters }

  describe "#valid?" do
    it "answers true when name, login, and password are present" do
      expect(subject.valid?).to be(true)
    end
  end

  describe "#invalid?" do
    it "answers true when name is not present" do
      subject.name = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when login is not present" do
      subject.login = nil
      expect(subject.invalid?).to be(true)
    end

    it "answers true when password is not present" do
      subject.password = nil
      expect(subject.invalid?).to be(true)
    end
  end
end
