$:.push File.expand_path("../lib", __FILE__)
require "auther/identity"

Gem::Specification.new do |spec|
  spec.name        = Auther::Identity.name
  spec.version     = Auther::Identity.version
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Brooke Kuhlmann"]
  spec.email       = ["brooke@alchemists.io"]
  spec.homepage    = "https://github.com/bkuhlmann/auther"
  spec.summary     = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication."
  spec.description = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication as a Rails Engine."
  spec.license     = "MIT"

  if ENV["RUBY_GEM_SECURITY"] == "enabled"
    spec.signing_key = File.expand_path("~/.ssh/gem-private.pem")
    spec.cert_chain = [File.expand_path("~/.ssh/gem-public.pem")]
  end

  spec.add_dependency "rails", "~> 4.1"
  spec.add_dependency "slim-rails"
  spec.add_dependency "sass-rails"
  spec.add_dependency "jquery-rails"
  spec.add_dependency "modernizr-rails"
  spec.add_dependency "foundation-rails", "~> 5.5"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-rescue"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "ammeter"
  spec.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.files            = Dir["app/**/*", "bin/**/*", "config/**/*", "lib/**/*", "vendor/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths    = ["lib"]
end
