module Auther
  module Identity
    def self.name
      "auther"
    end

    def self.label
      "Auther"
    end

    def self.version
      "4.1.0"
    end

    def self.label_version
      [label, version].join " "
    end
  end
end
