require "bundler/setup"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path "../dummy/config/environment", __FILE__
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "/dummy"

require "rspec/rails"
require "pry"
require "pry-byebug"
require "pry-remote"
require "pry-rescue"
require "pry-stack_explorer"
require "pry-vterm_aliases"
require "pry-git"
require "pry-doc"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run focus: true
end
