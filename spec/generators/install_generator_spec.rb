require "spec_helper"
require File.join(Dir.pwd, "lib/generators/auther/install/install_generator")

describe Auther::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  let(:temp_path) { File.expand_path "../../tmp", __FILE__ }
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
    it "installs initializer" do
      run_generator

      expect(File.exist?(initializer)).to be(true)
    end

    it "adds custom routes" do
      run_generator
      lines = File.open(routes_test, "r").readlines

      expect(lines[1]).to eq(%(  mount Auther::Engine => "/auther"\n))
      expect(lines[2]).to eq(%(  get "/login", to: "auther/session#new", as: "login"\n))
      expect(lines[3]).to eq(%(  delete "/logout", to: "auther/session#destroy", as: "logout"\n))
    end
  end
end
