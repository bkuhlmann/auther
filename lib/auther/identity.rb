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
      "9.2.0"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
