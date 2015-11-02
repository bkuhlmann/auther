require "bundler/setup"

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path "../dummy/config/environment", __FILE__
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "/dummy"

require "rspec/rails"
require "ammeter/init"

Dir[File.join(File.dirname(__FILE__), "support/extensions/**/*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "support/kit/**/*.rb")].each { |file| require file }
