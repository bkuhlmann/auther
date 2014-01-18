$:.push File.expand_path("../lib", __FILE__)
require "auther/version"

Gem::Specification.new do |s|
  s.name        = "auther"
  s.version     = Auther::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brooke Kuhlmann"]
  s.email       = ["brooke@redalchemist.com"]
  s.homepage    = "http://www.redalchemist.com"
  s.summary     = "A Rails Engine with simple, form-based authentication support."
  s.description = "A Rails Engine with simple, form-based authentication, session, and blacklist route support."
  s.license     = "MIT"

  unless ENV["TRAVIS"]
    s.signing_key = File.expand_path("~/.ssh/gem-private.pem")
    s.cert_chain  = [File.expand_path("~/.ssh/gem-public.pem")]
  end

  s.required_ruby_version = "~> 2.0"
  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "slim-rails", "~> 2.0"
  s.add_dependency "sass-rails", "~> 4.0"
  s.add_dependency "jquery-rails", "~> 3.0"
  s.add_dependency "modernizr-rails", "~> 2.7"
  s.add_dependency "foundation-rails", "~> 5.0"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "pry-rescue"
  s.add_development_dependency "pry-stack_explorer"
  s.add_development_dependency "pry-vterm_aliases"
  s.add_development_dependency "pry-git"
  s.add_development_dependency "pry-doc"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  s.add_development_dependency "guard-rspec"

  s.files            = Dir["app/**/*", "bin/**/*", "config/**/*", "lib/**/*", "vendor/**/*"]
  s.extra_rdoc_files = Dir["README*", "LICENSE*"]
  s.require_paths    = ["lib"]
end
