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
require "pry"
require "pry-remote"
require "pry-rescue"

case Gem.ruby_engine
  when "ruby"
    require "pry-byebug"
    require "pry-stack_explorer"
  when "jruby"
    require "pry-nav"
  when "rbx"
    require "pry-nav"
    require "pry-stack_explorer"
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
  config.order = "random"
  config.infer_base_class_for_anonymous_controllers = false

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:all) { GC.disable }
  config.after(:all) { GC.enable }
end
