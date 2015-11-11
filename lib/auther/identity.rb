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
      "5.0.0"
    end

    def self.label_version
      "#{label} #{version}"
    end
  end
end
