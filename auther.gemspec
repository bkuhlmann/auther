# frozen_string_literal: true

require_relative "lib/auther/identity"

Gem::Specification.new do |spec|
  spec.name = Auther::Identity::NAME
  spec.version = Auther::Identity::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/auther"
  spec.summary = "Enhances Rails with multi-account, " \
                 "form-based, database-less, application-wide authentication."
  spec.license = "Hippocratic-3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/auther/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/auther/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/auther",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/auther"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.0"
  spec.add_dependency "rails", "~> 7.0"
  spec.add_dependency "refinements", "~> 8.5"
  spec.add_dependency "sass-rails", "~> 6.0"
  spec.add_dependency "slim-rails", "~> 3.2"

  spec.files            = Dir["app/**/*", "config/**/*", "lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths    = ["lib"]
end
