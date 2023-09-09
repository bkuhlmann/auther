# frozen_string_literal: true

require "rails_helper"
require File.join(Dir.pwd, "lib/generators/auther/install/install_generator")

RSpec.describe Auther::InstallGenerator, type: :generator do
  destination Bundler.root.join("tmp")

  let(:temp_path) { Bundler.root.join "tmp" }
  let(:initializer) { temp_path.join "config/initializers/auther.rb" }
  let(:routes_template) { SPEC_ROOT.join "support/fixtures/config/routes.rb" }
  let(:routes_test) { temp_path.join "config/routes.rb" }

  before do
    prepare_destination
    FileUtils.mkdir File.join(temp_path, "config")
    FileUtils.cp routes_template, routes_test
  end

  after { FileUtils.rm_rf temp_path }

  describe "#install" do
    let :initialize_contents do
      <<~CONTENT
        # frozen_string_literal: true

        Rails.application.config.auther = {
          accounts: [
            {
              name: "admin",
              encrypted_login: ENV.fetch("AUTHER_ADMIN_LOGIN"),
              encrypted_password: ENV.fetch("AUTHER_ADMIN_PASSWORD"),
              paths: ["/admin"]
            }
          ],
          secret: ENV.fetch("AUTHER_SECRET")
        }
      CONTENT
    end

    it "installs initializer" do
      run_generator
      expect(File.read(initializer)).to eq(initialize_contents)
    end

    it "adds custom routes", :aggregate_failures do
      run_generator

      File.open routes_test, "r" do |file|
        lines = file.readlines

        expect(lines[3]).to eq(%(  mount Auther::Engine => "/auther"\n))
        expect(lines[4]).to eq(%(  get "/login", to: "auther/session#new", as: "login"\n))
        expect(lines[5]).to eq(%(  delete "/logout", to: "auther/session#destroy", as: "logout"\n))
      end
    end
  end
end
