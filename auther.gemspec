# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "auther"
  spec.version = "16.0.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/auther"
  spec.summary = "Enhances Rails with multi-account, " \
                 "form-based, database-less, application-wide authentication."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/auther/issues",
    "changelog_uri" => "https://alchemists.io/projects/auther/versions",
    "documentation_uri" => "https://alchemists.io/projects/auther",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Auther",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/auther"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.3"
  spec.add_dependency "rails", "~> 7.1"
  spec.add_dependency "refinements", "~> 12.0"

  spec.files = Dir["*.gemspec", "app/**/*", "config/**/*", "lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
end
