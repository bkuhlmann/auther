# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auther::Presenter::Account, type: :model do
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

  describe "#error?" do
    before { subject.valid? }

    context "when key exist" do
      let(:parameters) { {name: "test", login: "test@test.com"} }

      it "answers true" do
        expect(subject.error?(:password)).to eq(true)
      end
    end

    context "when key don't exist" do
      it "answers false" do
        expect(subject.error?(:login)).to eq(false)
      end
    end
  end

  describe "#error_message" do
    before { subject.valid? }

    context "when errors exist" do
      let(:parameters) { {} }

      it "answers full error message" do
        expect(subject.error_message(:password)).to eq("Password can't be blank")
      end
    end

    context "when errors don't exist" do
      it "answers an empty string" do
        expect(subject.error_message(:login)).to eq("")
      end
    end
  end
end
