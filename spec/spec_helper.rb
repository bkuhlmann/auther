require "bundler/setup"
require "coveralls"
Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path "../dummy/config/environment", __FILE__
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "/dummy"

require "rspec/rails"
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

  config.before(:all) { GC.disable }
  config.after(:all) { GC.enable }
end
