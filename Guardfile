# frozen_string_literal: true

guard :rspec, cmd: "NO_COVERAGE=true bin/rspec --format documentation" do
  watch %r(^spec/.+_spec\.rb$)
  watch(%r(^lib/(.+)\.rb$)) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch("spec/spec_helper.rb") { "spec" }

  # Rails
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch %r{^app/controllers/(.+)_(controller)\.rb$} do |m|
    [
      "spec/routing/#{m[1]}_routing_spec.rb",
      "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
      "spec/acceptance/#{m[1]}_spec.rb"
    ]
  end
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  watch("config/routes.rb") { "spec/routing" }
  watch("app/controllers/application_controller.rb") { "spec/controllers" }
  watch("spec/rails_helper.rb") { "spec" }

  # Capybara
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$}) { |m| "spec/features/#{m[1]}_spec.rb" }
end
