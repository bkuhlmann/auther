# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "auther/identity"

Gem::Specification.new do |spec|
  spec.name        = Auther::Identity.name
  spec.version     = Auther::Identity.version
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Brooke Kuhlmann"]
  spec.email       = ["brooke@alchemists.io"]
  spec.homepage    = "https://github.com/bkuhlmann/auther"
  spec.summary     = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication."
  spec.license     = "MIT"

  if File.exist?(Gem.default_key_path) && File.exist?(Gem.default_cert_path)
    spec.signing_key = Gem.default_key_path
    spec.cert_chain = [Gem.default_cert_path]
  end

  spec.required_ruby_version = "~> 2.4"
  spec.add_dependency "rails", "~> 5.0"
  spec.add_dependency "slim-rails", "~> 3.1"
  spec.add_dependency "sass-rails", "~> 5.0"
  spec.add_dependency "bourbon", "~> 4.2"
  spec.add_dependency "neat", "~> 1.8"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "gemsmith", "~> 8.2"
  spec.add_development_dependency "pg", "~> 0.19"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "pry-state", "~> 0.1"
  spec.add_development_dependency "bond", "~> 0.5"
  spec.add_development_dependency "wirb", "~> 2.0"
  spec.add_development_dependency "hirb", "~> 0.7"
  spec.add_development_dependency "awesome_print", "~> 1.7"
  spec.add_development_dependency "rspec-rails", "~> 3.5"
  spec.add_development_dependency "ammeter", "~> 1.1"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "reek", "~> 4.5"
  spec.add_development_dependency "rubocop", "~> 0.47"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"

  spec.files            = Dir["app/**/*", "bin/**/*", "config/**/*", "lib/**/*", "vendor/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths    = ["lib"]
end
