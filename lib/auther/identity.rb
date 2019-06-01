# frozen_string_literal: true

module Auther
  # Gem identity information.
  module Identity
    def self.name
      "auther"
    end

    def self.label
      "Auther"
    end

    def self.version
      "10.2.1"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
