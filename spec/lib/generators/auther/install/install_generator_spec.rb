# frozen_string_literal: true

require "rails_helper"
require File.join(Dir.pwd, "lib/generators/auther/install/install_generator")

# rubocop:disable RSpec/FilePath
RSpec.describe Auther::InstallGenerator, type: :generator do
  destination Bundler.root.join("tmp")

  let(:temp_path) { Bundler.root.join "tmp" }
  let(:initializer) { File.join temp_path, "config", "initializers", "auther.rb" }
  let(:routes_template) { File.join Dir.pwd, "spec", "support", "config", "routes.rb" }
  let(:routes_test) { File.join temp_path, "config", "routes.rb" }

  before do
    prepare_destination
    FileUtils.mkdir File.join(temp_path, "config")
    FileUtils.cp routes_template, routes_test
  end

  after { FileUtils.rm_rf temp_path }

  describe "#install" do
    let :initialize_contents do
      "# frozen_string_literal: true\n" \
      "\n" \
      "Rails.application.config.auther_settings = {\n" \
      "  accounts: [\n" \
      "    {\n" \
      "      name: \"admin\",\n" \
      "      encrypted_login: ENV[\"AUTHER_ADMIN_LOGIN\"],\n" \
      "      encrypted_password: ENV[\"AUTHER_ADMIN_PASSWORD\"],\n" \
      "      paths: [\"/admin\"]\n" \
      "    }\n" \
      "  ],\n" \
      "  secret: ENV[\"AUTHER_SECRET\"]\n" \
      "}\n"
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
# rubocop:enable RSpec/FilePath
