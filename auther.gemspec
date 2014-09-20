$:.push File.expand_path("../lib", __FILE__)
require "auther/version"

Gem::Specification.new do |spec|
  spec.name        = "auther"
  spec.version     = Auther::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Brooke Kuhlmann"]
  spec.email       = ["brooke@redalchemist.com"]
  spec.homepage    = "https://github.com/bkuhlmann/auther"
  spec.summary     = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication."
  spec.description = "Enhances Rails with multi-account, form-based, database-less, application-wide authentication as a Rails Engine."
  spec.license     = "MIT"

  unless ENV["CI"] == "true"
    spec.signing_key = File.expand_path("~/.ssh/gem-private.pem")
    spec.cert_chain = [File.expand_path("~/.ssh/gem-public.pem")]
  end

  case Gem.ruby_engine
    when "ruby"
      spec.add_development_dependency "pry-byebug"
      spec.add_development_dependency "pry-stack_explorer"
    when "jruby"
      spec.add_development_dependency "pry-nav"
    when "rbx"
      spec.add_development_dependency "pry-nav"
      spec.add_development_dependency "pry-stack_explorer"
    else
      raise RuntimeError.new("Unsupported Ruby Engine!")
  end

  spec.add_dependency "rails", "~> 4.0"
  spec.add_dependency "slim-rails", "~> 2.1"
  spec.add_dependency "sass-rails", "~> 4.0"
  spec.add_dependency "jquery-rails", "~> 3.1"
  spec.add_dependency "modernizr-rails", "~> 2.7"
  spec.add_dependency "foundation-rails", "~> 5.3.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-rescue"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "ammeter"
  spec.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.files            = Dir["app/**/*", "bin/**/*", "config/**/*", "lib/**/*", "vendor/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths    = ["lib"]
end
