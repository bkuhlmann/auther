# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require File.expand_path "support/dummy/config/environment", __dir__
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "/dummy"

require "spec_helper"
require "rspec/rails"
require "ammeter/init"

GC.auto_compact = true
GC.verify_compaction_references double_heap: true, toward: :empty

RSpec.configure do |config|
  config.include AbstractController::Translation
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper, type: :job
  config.infer_spec_type_from_file_location!
end

__END__

real  0m6.506s
user  0m3.401s
sys 0m2.045s
