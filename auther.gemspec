$:.push File.expand_path("../lib", __FILE__)
require "auther/version"

Gem::Specification.new do |s|
  s.name        = "auther"
  s.version     = Auther::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brooke Kuhlmann"]
  s.email       = ["brooke@redalchemist.com"]
  s.homepage    = "https://github.com/bkuhlmann/auther"
  s.summary     = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication."
  s.description = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication as a Rails Engine."
  s.license     = "MIT"

  unless ENV["CI"] == "true"
    spec.signing_key = File.expand_path("~/.ssh/gem-private.pem")
    spec.cert_chain = [File.expand_path("~/.ssh/gem-public.pem")]
  end

  case Gem.ruby_engine
    when "ruby"
      s.add_development_dependency "pry-byebug"
      s.add_development_dependency "pry-stack_explorer"
    when "jruby"
      s.add_development_dependency "pry-nav"
    when "rbx"
      s.add_development_dependency "pry-nav"
      s.add_development_dependency "pry-stack_explorer"
    else
      raise RuntimeError.new("Unsupported Ruby Engine!")
  end

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "slim-rails", "~> 2.1"
  s.add_dependency "sass-rails", "~> 4.0"
  s.add_dependency "jquery-rails", "~> 3.1"
  s.add_dependency "modernizr-rails", "~> 2.7"
  s.add_dependency "foundation-rails", "~> 5.2"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "pry-rescue"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "ammeter"
  s.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "codeclimate-test-reporter"

  s.files            = Dir["app/**/*", "bin/**/*", "config/**/*", "lib/**/*", "vendor/**/*"]
  s.extra_rdoc_files = Dir["README*", "LICENSE*"]
  s.require_paths    = ["lib"]
end
