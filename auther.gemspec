# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "auther"
  spec.version = "13.0.0"
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
    "label" => "Auther",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/auther"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "rails", "~> 7.0"
  spec.add_dependency "refinements", "~> 9.1"
  spec.add_dependency "sass-rails", "~> 6.0"
  spec.add_dependency "slim-rails", "~> 3.3"

  spec.files = Dir["*.gemspec", "app/**/*", "config/**/*", "lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths = ["lib"]
end
